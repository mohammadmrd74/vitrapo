import { Module } from '@nestjs/common';
import { PrismaModule } from './database/prisma.module';
import { ConfigModule } from '@nestjs/config';
import appConfig from 'src/common/config/appConfiguration';
import databaseConfig from 'src/common/config/databaseConfiguration';
import { UserModule } from './user/user.module';
@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      load: [appConfig, databaseConfig],
    }),
    PrismaModule,
    UserModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
