import { Module } from '@nestjs/common';
import { ApplicantService } from './applicant.service';
import { ApplicantController } from './applicant.controller';

@Module({
  providers: [ApplicantService],
  controllers: [ApplicantController],
})
export class ApplicantModule {}
