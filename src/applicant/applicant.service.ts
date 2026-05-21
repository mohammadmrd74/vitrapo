import {
  Body,
  HttpException,
  HttpStatus,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import {
  AdminConfirmApplicantDto,
  ConfirmApplicantDto,
  CreateApplicantDataGroupDto,
  CreateApplicantDto,
  CreateApplicantInformationDto,
  CreateAssignExpertDto,
  CreateMultiApplicantInformationDto,
} from './dto/applicant.dto';
import { vtUser } from 'src/auth/authentication.guard';
import { dbError } from 'src/common/dbError';
import { selectedUser } from 'src/document/dto/createDocument.dto';

function keyExistsInArray(array, obj: object) {
  // Get the keys from the second object
  const objKeys = Object.keys(obj);

  // Check if each key exists in the array
  for (const key of objKeys) {
    const exists = array.some((item) => item.key === key);
    if (!exists) {
      return false;
    }
  }

  return true;
}

@Injectable()
export class ApplicantService {
  constructor(private prismaService: PrismaService) {}

  async insertApplicationMultiInformation(
    applicantInformation: CreateMultiApplicantInformationDto,
  ) {
    try {
      const createApplicantInformation =
        await this.prismaService.applicantInformation.createMany({
          data: applicantInformation.dataGroupId.map((id) => ({
            applicantId: applicantInformation.applicantId,
            contractId: -1,
            dataGroupId: id,
          })),
        });

      return createApplicantInformation;
    } catch (error) {
      console.log(error);
      dbError(error);
      throw new NotFoundException();
    }
  }
  async deleteApplicationMultiInformation(
    applicantInformation: CreateMultiApplicantInformationDto,
  ) {
    try {
      const deleteApplicantInformation =
        await this.prismaService.applicantInformation.deleteMany({
          where: {
            applicantId: applicantInformation.applicantId,
            contractId: -1,
            dataGroupId: {
              in: applicantInformation.dataGroupId,
            },
          },
        });

      return deleteApplicantInformation;
    } catch (error) {
      console.log(error);
      dbError(error);
      throw new NotFoundException();
    }
  }
  async insertApplicantInformation(
    applicantInformation: CreateApplicantInformationDto,
  ) {
    try {
      //get fields
      const dbFields = await this.prismaService.applicantDataGroup.findUnique({
        where: {
          id: applicantInformation.dataGroupId,
        },
        select: {
          fields: true,
        },
      });

      if (!dbFields) throw new NotFoundException();
      if (!applicantInformation.values) {
        try {
          const upsertApplicantInformation =
            await this.prismaService.applicantInformation.upsert({
              where: {
                applicantId_contractId_dataGroupId: {
                  applicantId: applicantInformation.applicantId,
                  contractId: -1,
                  dataGroupId: applicantInformation.dataGroupId,
                },
              },
              update: {
                values: JSON.stringify({}),
              },
              create: {
                ...applicantInformation,
                values: JSON.stringify(applicantInformation.values ?? {}),
              },
            });

          return upsertApplicantInformation;
        } catch (error) {
          console.log(error);
          dbError(error);
          throw new NotFoundException();
        }
      }
      const parsedDbFields = dbFields.fields
        ? JSON.parse(dbFields.fields)
        : [];
      if (keyExistsInArray(parsedDbFields, applicantInformation.values)) {
        try {
          const upsertApplicantInformation =
            await this.prismaService.applicantInformation.upsert({
              where: {
                applicantId_contractId_dataGroupId: {
                  applicantId: applicantInformation.applicantId,
                  contractId: -1,
                  dataGroupId: applicantInformation.dataGroupId,
                },
              },
              update: {
                values: JSON.stringify(applicantInformation.values),
              },
              create: {
                ...applicantInformation,
                values: JSON.stringify(applicantInformation.values),
              },
            });

          return upsertApplicantInformation;
        } catch (error) {
          console.log(error);
          dbError(error);
          throw new NotFoundException();
        }
      } else {
        throw new HttpException(
          'input keys are incorrect for this data group.',
          HttpStatus.BAD_REQUEST,
        );
      }
    } catch (error) {
      if (error.response) throw error;
      console.log(error);

      dbError(error);
      throw new NotFoundException();
    }
  }
  async confirmData(user: vtUser, applicant: ConfirmApplicantDto) {
    try {
      const confirmed = await this.prismaService.applicant.update({
        where: {
          id: applicant.applicantId,
          users: {
            id: user.sub,
          },
        },
        data: {
          isConfirmed: true,
        },
      });

      return confirmed;
    } catch (error) {
      dbError(error);

      throw new NotFoundException();
    }
  }

  async adminConfirmData(user: vtUser, applicant: AdminConfirmApplicantDto) {
    try {
      const confirmed = await this.prismaService.applicant.update({
        where: {
          id: applicant.applicantId,
        },
        data: {
          isAdminConfirmed: applicant.confirm,
        },
      });

      return confirmed;
    } catch (error) {
      dbError(error);

      throw new NotFoundException();
    }
  }

  async assignExpert(assignExpertBody: CreateAssignExpertDto) {
    try {
      const applicantExperts =
        await this.prismaService.applicantExpert.createMany({
          data: assignExpertBody.expertIds.map((ex) => ({
            applicantId: assignExpertBody.applicantId,
            expertId: ex,
          })),
        });

      return applicantExperts;
    } catch (error) {
      dbError(error);

      throw new NotFoundException();
    }
  }

  async deleteExpert(assignExpertBody: CreateAssignExpertDto) {
    try {
      const applicantExperts =
        await this.prismaService.applicantExpert.deleteMany({
          where: {
            applicantId: assignExpertBody.applicantId,
            expertId: {
              in: assignExpertBody.expertIds,
            },
          },
        });

      return applicantExperts;
    } catch (error) {
      dbError(error);

      throw new NotFoundException();
    }
  }

  async insertApplicantDataGroup(
    applicantDataGroup: CreateApplicantDataGroupDto,
  ) {
    try {
      const createGroup = await this.prismaService.applicantDataGroup.create({
        data: {
          ...applicantDataGroup,
          fields: JSON.stringify(applicantDataGroup.fields),
        },
      });

      return {
        id: createGroup.id,
      };
    } catch (error) {
      console.log(error);

      dbError(error);

      throw new NotFoundException();
    }
  }

  async addApplicant(applicant: CreateApplicantDto, user: vtUser) {
    try {
      const createdApplicant = await this.prismaService.applicant.create({
        data: {
          ...applicant,
          sellerId: user.sub,
          passportExpireDate: new Date(applicant.passportExpireDate),
          passportIssueDate: new Date(applicant.passportIssueDate),
        },
      });

      return {
        id: createdApplicant.id,
        username: createdApplicant.userId,
      };
    } catch (error) {
      console.log(error);
      dbError(error);
      throw new NotFoundException();
    }
  }

  async getApplicant(user: vtUser) {
    try {
      const applicant = await this.prismaService.applicant.findMany({
        where: {
          userId: user.sub,
        },
        include: {
          users: {
            select: {
              id: true,
              name: true,
              family: true,
              roleId: true,
            },
          },
          seller: {
            select: {
              id: true,
              name: true,
              family: true,
            },
          },
          countries: {
            include: {
              countryTranslation: true,
            },
          },
        },
      });

      return applicant;
    } catch (error) {
      throw new NotFoundException();
    }
  }

  async getApplicantList(take: number, skip: number, user: vtUser) {
    try {
      console.log({
        some: {
          expertId: user.sub,
        },
      });

      const applicants = await this.prismaService.applicant.findMany({
        include: {
          users: true,
          countries: {
            include: {
              countryTranslation: true,
            },
          },
          applicantContractDocument: {
            select: {
              status: true,
            },
          },
          applicantExpert: {
            select: {
              expertId: true,
              users: {
                select: {
                  name: true,
                  family: true,
                },
              },
            },
          },
        },
        where:
          user.roleId === 3
            ? {}
            : {
                OR: [
                  {
                    applicantExpert: {
                      some: {
                        expertId: user.sub,
                      },
                    },
                  },
                  {
                    sellerId: user.sub,
                  },
                ],
              },
        take: take,
        skip: skip,
      });

      return applicants.map((app) => {
        const appStatus = app.applicantContractDocument.find(
          (status) => status.status === selectedUser.waiting,
        );

        // eslint-disable-next-line @typescript-eslint/no-unused-vars
        const { applicantContractDocument, ...newapp } = app;

        return {
          ...newapp,
          hasMessage: appStatus ? true : false,
        };
      });
    } catch (error) {
      throw new NotFoundException();
    }
  }

  async getDataGroup(applicantId) {
    try {
      const dataGroup = await this.prismaService.applicantDataGroup.findMany({
        where: {
          applicantInformation: {
            some: {
              applicantId: applicantId,
            },
          },
        },
        include: {
          applicantInformation: true,
        },
      });
      const rightData = dataGroup.map((d) => {
        const parsedFields: Array<{ key: string; type: string }> = d.fields
          ? JSON.parse(d.fields)
          : [];
        return {
          id: d.id,
          title: d.title,
          description: d.description,
          fields: parsedFields.map((f) => {
            const val = d.applicantInformation.find((appInfo) => {
              const vals = appInfo.values ? JSON.parse(appInfo.values) : null;
              return vals ? vals[f.key] : '';
            });
            const valValues = val?.values ? JSON.parse(val.values) : {};
            return {
              ...f,
              value: val
                ? valValues[f.key]
                : f.type === 'combo' || f.type === 'checkbox'
                  ? []
                  : '',
            };
          }),
        };
      });

      return rightData;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }
}
