import { Injectable } from '@nestjs/common';
import { MinioClientService } from 'src/minio-client/minio-client.service';

@Injectable()
export class UserService {
  constructor(private minioClientService: MinioClientService) {}

  async uploadSingle(image: Express.Multer.File, bucket: string) {
    const uploaded_image = await this.minioClientService.upload(image, bucket);

    return {
      image_url: uploaded_image.url,
      message: 'Successfully uploaded to MinIO S3',
    };
  }
}
