import {
  Body,
  Controller,
  Get,
  Post,
  UseGuards,
  Request,
  ParseIntPipe,
  Query,
  DefaultValuePipe,
} from '@nestjs/common';
import {
  CreateApplicantDataGroupDto,
  CreateApplicantDto,
  CreateApplicantInformationDto,
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

  @Get('/list')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getApplicantList(
    @Query('take', new DefaultValuePipe(20), ParseIntPipe) take: number,
    @Query('skip', new DefaultValuePipe(0), ParseIntPipe) skip: number,
  ) {
    return this.applicantService.getApplicantList(take, skip);
  }

  @Get('/datagroup')
  @UseGuards(AuthenticationGuard)
  getDateGroup(@Query('applicantId', ParseIntPipe) applicantId: number) {
    return this.applicantService.getDataGroup(applicantId);
  }

  @Post('/datagroup')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  insertApplicantDataGroup(
    @Body() applicantDataGroup: CreateApplicantDataGroupDto,
  ) {
    return this.applicantService.insertApplicantDataGroup(applicantDataGroup);
  }

  @Post('/information')
  @UseGuards(AuthenticationGuard)
  insertApplicantInformation(
    @Body() applicantinformation: CreateApplicantInformationDto,
  ) {
    return this.applicantService.insertApplicantInformation({
      ...applicantinformation,
      contractId: -1,
    });
  }
}
