import {
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
                values: {},
              },
              create: applicantInformation,
            });

          return upsertApplicantInformation;
        } catch (error) {
          console.log(error);
          dbError(error);
          throw new NotFoundException();
        }
      }
      if (keyExistsInArray(dbFields.fields, applicantInformation.values)) {
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
                values: applicantInformation.values,
              },
              create: applicantInformation,
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
          skipDuplicates: true,
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
        data: applicantDataGroup,
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

  async addApplicant(applicant: CreateApplicantDto) {
    try {
      const createdApplicant = await this.prismaService.applicant.create({
        data: {
          ...applicant,
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
          users: true,
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
        },
        where:
          user.roleId === 3
            ? {}
            : {
                applicantExpert: {
                  some: {
                    expertId: user.sub,
                  },
                },
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
        return {
          id: d.id,
          title: d.title,
          description: d.description,
          fields: (d.fields as Array<{ key: string; type: string }>).map(
            (f) => {
              const val = d.applicantInformation.find((appInfo) =>
                appInfo.values ? appInfo.values[f.key] : '',
              );

              return {
                ...f,
                value: val
                  ? val.values[f.key]
                  : f.type === 'combo' || f.type === 'checkbox'
                    ? []
                    : '',
              };
            },
          ),
        };
      });

      return rightData;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }
}
