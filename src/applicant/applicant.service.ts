import {
  HttpException,
  HttpStatus,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import {
  ConfirmApplicantDto,
  CreateApplicantDataGroupDto,
  CreateApplicantDto,
  CreateApplicantInformationDto,
} from './dto/applicant.dto';
import { vtUser } from 'src/auth/authentication.guard';
import { dbError } from 'src/common/dbError';

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

  async getApplicantList(take, skip) {
    try {
      const applicants = await this.prismaService.applicant.findMany({
        include: {
          users: true,
          countries: {
            include: {
              countryTranslation: true,
            },
          },
        },
        take: take,
        skip: skip,
      });

      return applicants;
    } catch (error) {
      throw new NotFoundException();
    }
  }

  async getDataGroup(applicantId) {
    try {
      const dataGroup = await this.prismaService.applicantDataGroup.findMany({
        where: {
          applicantInformation: {
            every: {
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
