import {
  Body,
  Controller,
  Get,
  Post,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  CreateApplicantDataGroupDto,
  CreateApplicantDto,
} from './dto/applicant.dto';
// import { applicant } from '@prisma/client';
import { ApplicantService } from './applicant.service';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';

@Controller('applicant')
export class ApplicantController {
  constructor(private readonly applicantService: ApplicantService) {}

  @Post('/')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addApplicant(@Body() applicant: CreateApplicantDto) {
    return this.applicantService.addApplicant(applicant);
  }

  @Get('/')
  @UseGuards(AuthenticationGuard)
  getApplicant(@Request() req: Request & { user: vtUser }) {
    return this.applicantService.getApplicant(req.user);
  }

  @Post('/datagroup')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  insertApplicantDataGroup(
    @Body() applicantDataGroup: CreateApplicantDataGroupDto,
  ) {
    return this.applicantService.insertApplicantDataGroup(applicantDataGroup);
  }
}
