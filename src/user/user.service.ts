import { HttpException, HttpStatus, Injectable } from '@nestjs/common';
import { MinioClientService } from 'src/minio-client/minio-client.service';
import { CreateUserDto } from './dto/CreateUser.dto';
import { PrismaService } from 'src/database/prisma.service';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UserService {
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
  ) {}

  async registerUser(
    createUser: CreateUserDto,
    file: Express.Multer.File,
    bucket: string,
  ) {
    const imageUrl = await this.uploadSingle(file, bucket);
    const hash = await bcrypt.hash(createUser.password, 10);
    try {
      const user = await this.prismaService.users.create({
        data: {
          ...createUser,
          email: createUser.email || null,
          password: hash,
          profilePicture: imageUrl,
        },
      });

      return {
        statusCode: 200,
        message: {
          id: user.id,
          username: user.username,
          profilePicture: user.profilePicture,
        },
      };
    } catch (error) {
      if (error.code === 'P2002') {
        throw new HttpException(
          'Username already exists',
          HttpStatus.BAD_REQUEST,
        );
      }
    }
  }

  async uploadSingle(image: Express.Multer.File, bucket: string) {
    const uploaded_image = await this.minioClientService.upload(image, bucket);

    return uploaded_image.url;
  }
}
