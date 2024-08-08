import {
  HttpException,
  HttpStatus,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import { CreateApplicantDto } from './dto/applicant.dto';
import { vtUser } from 'src/auth/authentication.guard';

@Injectable()
export class ApplicantService {
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
      if (error.code === 'P2002') {
        throw new HttpException(
          'applicant with this country and visa type already exists',
          HttpStatus.BAD_REQUEST,
        );
      } else throw new NotFoundException();
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
