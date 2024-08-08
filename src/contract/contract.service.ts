import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateContractDto } from './dto/createContract.dto';
import { MinioClientService } from 'src/minio-client/minio-client.service';
import { PrismaService } from 'src/database/prisma.service';
import { dbError } from 'src/common/dbError';
import { vtUser } from 'src/auth/authentication.guard';

@Injectable()
export class ContractService {
  async getContract(applicantId: number, user: vtUser) {
    console.log(applicantId);

    try {
      const contract = await this.prismaService.contracts.findMany({
        where: {
          applicantId: applicantId,
          applicant: {
            userId: user.sub,
          },
        },
      });

      return contract;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
  ) {}

  async insertContract(
    createContract: CreateContractDto,
    file: Express.Multer.File,
    bucket: string,
  ) {
    try {
      const uploaded_image = await this.minioClientService.upload(file, bucket);
      const createdContract = await this.prismaService.contracts.create({
        data: {
          ...createContract,
          applicantId: parseInt(createContract.applicantId, 10),
          totalPrice: parseInt(createContract.totalPrice, 10),
          istallmetNumbers: parseInt(createContract.istallmetNumbers, 10),
          issueDate: new Date(createContract.issueDate),
          executeDate: new Date(createContract.executeDate),
          image: uploaded_image.url,
        },
      });

      return createdContract;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }
}
