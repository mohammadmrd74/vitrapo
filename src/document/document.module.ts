import { Module } from '@nestjs/common';
import { DocumentService } from './document.service';
import { DocumentController } from './document.controller';
import { MinioClientModule } from 'src/minio-client/minio-client.module';

@Module({
  imports: [MinioClientModule],
  controllers: [DocumentController],
  providers: [DocumentService],
})
export class DocumentModule {}
