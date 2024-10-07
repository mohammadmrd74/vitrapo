import { Module } from '@nestjs/common';
import { MinioClientService } from './minio-client.service';
import { MinioModule } from 'nestjs-minio-client';
import { ConfigModule, ConfigService } from '@nestjs/config';
@Module({
  imports: [
    MinioModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        endPoint: configService.get<string>('MINIO_ENDPOINT'),
        port: parseInt(configService.get<string>('MINIO_PORT')),
        useSSL: false,
        accessKey: configService.get<string>('MINIO_ACCESSKEY'),
        secretKey: configService.get<string>('MINIO_SECRETKEY'),
      }),
      inject: [ConfigService],
    }),
  ],
  providers: [MinioClientService],
  exports: [MinioClientService],
})
export class MinioClientModule {}
