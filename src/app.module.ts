import { Module } from '@nestjs/common';
import { PrismaModule } from './database/prisma.module';
import { ConfigModule } from '@nestjs/config';
import appConfig from 'src/common/config/appConfiguration';
import databaseConfig from 'src/common/config/databaseConfiguration';
import { UserModule } from './user/user.module';
import { ApplicantModule } from './applicant/applicant.module';
import { ContractModule } from './contract/contract.module';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, databaseConfig],
    }),
    PrismaModule,
    UserModule,
    ApplicantModule,
    ContractModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
