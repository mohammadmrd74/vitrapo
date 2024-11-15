import { Module } from '@nestjs/common';
import { PrismaModule } from './database/prisma.module';
import { ConfigModule } from '@nestjs/config';
import appConfig from 'src/common/config/appConfiguration';
import databaseConfig from 'src/common/config/databaseConfiguration';
import { UserModule } from './user/user.module';
import { ApplicantModule } from './applicant/applicant.module';
import { ContractModule } from './contract/contract.module';
import { DocumentModule } from './document/document.module';
import { TicketModule } from './ticket/ticket.module';
import { NotificationModule } from './notification/notification.module';
import { AdminModule } from './admin/admin.module';
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
    DocumentModule,
    TicketModule,
    NotificationModule,
    AdminModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
