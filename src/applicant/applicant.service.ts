import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import {
  CreateApplicantDataGroupDto,
  CreateApplicantDto,
} from './dto/applicant.dto';
import { vtUser } from 'src/auth/authentication.guard';
import { dbError } from 'src/common/dbError';

@Injectable()
export class ApplicantService {
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
  constructor(private prismaService: PrismaService) {}

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
      });

      return applicant;
    } catch (error) {
      throw new NotFoundException();
    }
  }
}
