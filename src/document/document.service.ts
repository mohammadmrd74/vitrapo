import {
  HttpException,
  HttpStatus,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import {
  ChangeStatusDocumentDto,
  CreateApplicantDocumentDto,
  CreateContractApplicantDocumenFileDto,
  CreateContractApplicantDocumenMessageDto,
  CreateDocumentDto,
  selectedUser,
} from './dto/createDocument.dto';
import { dbError } from 'src/common/dbError';
import { vtUser } from 'src/auth/authentication.guard';
import { MinioClientService } from 'src/minio-client/minio-client.service';

@Injectable()
export class DocumentService {
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
  ) {}

  async addDocument(document: CreateDocumentDto) {
    if (document.documentGroupId) {
      try {
        return await this.prismaService.documents.create({
          data: document,
        });
      } catch (error) {
        dbError(error);

        throw error;
      }
    } else if (document.documentGroupTitle && !document.documentGroupId) {
      try {
        return await this.prismaService.documents.create({
          data: {
            docTitle: document.docTitle,
            docDescription: document.docDescription,
            doumentGroups: {
              create: {
                name: document.documentGroupTitle,
              },
            },
          },
        });
      } catch (error) {
        console.log(error);

        dbError(error);

        throw error;
      }
    } else {
      throw new Error(
        'Either documentGroupId or documentGroupTitle must be provided',
      );
    }
  }
  async changeStatus(document: ChangeStatusDocumentDto) {
    try {
      return await this.prismaService.applicantContractDocument.update({
        where: {
          id: document.documentId,
        },
        data: document.isMain
          ? {
              status: document.status,
            }
          : {
              translateStatus: document.status,
            },
      });
    } catch (error) {
      console.log(error);

      dbError(error);
    }
  }

  async addDocumentForApplicant(body: CreateApplicantDocumentDto) {
    try {
      const insertObjects = body.documentIds.map((item) => ({
        applicantId: body.applicantId,
        contractId: body.contractId,
        documentId: item,
      }));
      return await this.prismaService.applicantContractDocument.createMany({
        data: insertObjects,
        skipDuplicates: true,
      });
    } catch (error) {
      console.log(error);

      dbError(error);

      throw error;
    }
  }

  async deleteDocumentForApplicant(body: CreateApplicantDocumentDto) {
    try {
      return await this.prismaService.applicantContractDocument.deleteMany({
        where: {
          applicantId: body.applicantId,
          contractId: body.contractId,
          documentId: {
            in: body.documentIds,
          },
        },
      });
    } catch (error) {
      console.log(error);

      dbError(error);

      throw error;
    }
  }

  async getAllDocuments() {
    return this.prismaService.documents.findMany({
      include: {
        doumentGroups: true,
      },
    });
  }

  async getDocument(
    applicantId: number,
    contractId: number,
    canAccess: boolean = false,
    user: vtUser,
  ) {
    try {
      const applicantDocuments =
        await this.prismaService.doumentGroups.findMany({
          where: {
            documents: {
              some: {
                applicantContractDocument: {
                  some: canAccess
                    ? { applicantId: applicantId, contractId: contractId }
                    : {
                        applicantId: applicantId,
                        contractId: contractId,
                      },
                },
              },
            },
          },
          include: {
            documents: {
              select: {
                docTitle: true,
                docDescription: true,
                hasTranslate: true,
                id: true,
                applicantContractDocument: {
                  select: {
                    id: true,
                    original: true,
                    translate: true,
                    wantTranslate: true,
                    status: true,
                    translateStatus: true,
                    lastReadByUsers: {
                      select: {
                        userId: true,
                        lastReadId: true,
                      },
                    },
                    applicantContractDocumentMessage: {
                      select: {
                        id: true,
                      },
                    },
                  },
                },
              },
              where: {
                applicantContractDocument: {
                  some: {
                    applicantId: applicantId,
                    contractId: contractId,
                  },
                },
              },
            },
          },
        });

      applicantDocuments.forEach((ad) => {
        ad.documents.forEach((doc) => {
          const lastId = doc.applicantContractDocument[0].lastReadByUsers.find(
            (ls) => ls.userId === user.sub,
          );
          let unread_count = 0;
          if (lastId) {
            const unread_array: Array<{ id: number }> =
              doc.applicantContractDocument[0].applicantContractDocumentMessage.filter(
                (ff) => ff.id > lastId.lastReadId,
              );
            unread_count = unread_array.length;
          } else {
            unread_count =
              doc.applicantContractDocument[0].applicantContractDocumentMessage
                .length;
          }
          doc.applicantContractDocument[0]['unread_count'] = unread_count;
        });
      });

      return applicantDocuments;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }

  async insertContractApplicantDocument(
    body: CreateContractApplicantDocumenFileDto,
    files: {
      original?: Express.Multer.File[];
      translate?: Express.Multer.File[];
    },
  ) {
    if (!files.original && !files.translate)
      throw new HttpException(
        'Please send at least one file.',
        HttpStatus.UNPROCESSABLE_ENTITY,
      );

    let originalFilePath: string;
    let translateFilePath: string;
    try {
      const updateBody = {
        status: selectedUser.waiting,
      };
      if (files.original && files.original[0]) {
        originalFilePath = await this.uploadFile(
          body.applicantId,
          files.original[0],
        );
        updateBody['original'] = originalFilePath;
      }
      if (files.translate && files.translate[0]) {
        translateFilePath = await this.uploadFile(
          body.applicantId,
          files.translate[0],
        );
        updateBody['translate'] = translateFilePath;
      }

      const updatedInstallment =
        await this.prismaService.applicantContractDocument.update({
          where: {
            applicantId_contractId_documentId: {
              applicantId: parseInt(body.applicantId, 10),
              contractId: parseInt(body.contractId, 10),
              documentId: parseInt(body.documentId, 10),
            },
          },
          data: updateBody,
        });

      return updatedInstallment;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async insertContractApplicantMessage(
    body: CreateContractApplicantDocumenMessageDto,
    user: vtUser,
  ) {
    try {
      return await this.prismaService.applicantContractDocumentMessage.create({
        data: {
          ...body,
          userId: user.sub,
        },
      });
    } catch (error) {
      console.log(error);

      dbError(error);

      throw error;
    }
  }

  async uploadFile(applicantId: string, file: Express.Multer.File) {
    try {
      const uploaded_file = await this.minioClientService.upload(
        file,
        `applicantdocuments`,
      );

      return uploaded_file.url;
    } catch (error) {
      throw new Error('upload error.');
    }
  }

  async getContractApplicantMessage(
    applicantContractDocumentId: number,
    user: vtUser,
  ) {
    try {
      const applicantDocumentMessage =
        await this.prismaService.applicantContractDocumentMessage.findMany({
          where: {
            ACDId: applicantContractDocumentId,
          },
          select: {
            id: true,
            message: true,
            createdAt: true,
            users: {
              select: {
                id: true,
                username: true,
                name: true,
                family: true,
                profilePicture: true,
              },
            },
          },
        });

      if (applicantDocumentMessage.length > 0) {
        await this.prismaService.lastReadByUsers.upsert({
          update: {
            lastReadId: applicantDocumentMessage.slice(-1)[0].id,
          },
          where: {
            userId_ACDId: {
              userId: user.sub,
              ACDId: applicantContractDocumentId,
            },
          },
          create: {
            ACDId: applicantContractDocumentId,
            userId: user.sub,
            lastReadId: applicantDocumentMessage.slice(-1)[0].id,
          },
        });
      }

      return applicantDocumentMessage;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }
}
