import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { UserController } from './user.controller';
import { MinioClientModule } from '../minio-client/minio-client.module';

@Module({
  imports: [MinioClientModule],
  providers: [UserService],
  controllers: [UserController],
})
export class UserModule {}
