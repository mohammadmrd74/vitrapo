import {
  HttpException,
  HttpStatus,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateContractDto } from './dto/createContract.dto';
import { MinioClientService } from 'src/minio-client/minio-client.service';
import { PrismaService } from 'src/database/prisma.service';
import { dbError } from 'src/common/dbError';
import { vtUser } from 'src/auth/authentication.guard';
import {
  CreateContractInstallmentDto,
  CreateContractInstallmentFileDto,
  CreateInstallmentMessageDto,
} from './dto/createContractInstallment.dto';

@Injectable()
export class ContractService {
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
  ) {}
  async getContract(applicantId: number, user: vtUser) {
    try {
      const contract = await this.prismaService.contracts.findMany({
        where: {
          applicantId: applicantId,
          applicant: {
            userId: user.sub,
            isConfirmed: true,
          },
        },
      });
      if (!contract.length) {
        throw new HttpException(
          `applicant not confirmed`,
          HttpStatus.FORBIDDEN,
        );
      }

      return contract;
    } catch (error) {
      console.log(error);

      throw error;
    }
  }

  async getContractList(applicantId: number) {
    try {
      const contract = await this.prismaService.contracts.findMany({
        where: {
          applicantId: applicantId,
        },
      });

      return contract;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }

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

  async insertContractInstallment(
    createContractInstallment: CreateContractInstallmentDto,
  ) {
    const contract = await this.prismaService.contracts.findUnique({
      where: { id: createContractInstallment.contractId },
      select: { applicantId: true },
    });

    if (contract) {
      try {
        const createdContract = await this.prismaService.installments.create({
          data: {
            ...createContractInstallment,
            applicantId: contract.applicantId,
            dueDate: new Date(createContractInstallment.dueDate),
          },
        });

        return createdContract;
      } catch (error) {
        console.log(error);
        dbError(error);

        throw error;
      }
    } else {
      throw new HttpException(`applicant doesn't exist.`, HttpStatus.NOT_FOUND);
    }
  }

  async getContractInstallments(
    applicantId: number,
    contractId: number,
    user: vtUser,
  ) {
    try {
      const installments = await this.prismaService.installments.findMany({
        where: {
          applicantId: applicantId,
          contractId: contractId,
          applicant: {
            userId: user.sub,
            isConfirmed: true,
          },
        },
      });
      if (!installments.length) {
        throw new HttpException(
          `applicant not confirmed`,
          HttpStatus.FORBIDDEN,
        );
      }

      return installments;
    } catch (error) {
      console.log(error);

      throw error;
    }
  }

  async insertInstallmentFile(
    installment: CreateContractInstallmentFileDto,
    files: Array<Express.Multer.File>,
  ) {
    try {
      const uploaded_files = await this.minioClientService.uploadMany(
        files,
        'installments',
      );
      const updatedInstallment = await this.prismaService.installments.update({
        where: {
          id: parseInt(installment.installmentId, 10),
        },
        data: {
          documentFile: uploaded_files,
        },
      });

      return updatedInstallment;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async insertInstallmentMessage(
    createInstallmentMessage: CreateInstallmentMessageDto,
    user: vtUser,
  ) {
    try {
      const createdContract =
        await this.prismaService.installmentMessages.create({
          data: {
            ...createInstallmentMessage,
            userId: user.sub,
          },
        });

      return createdContract;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async getInstallmentMessage(installmentId: number, user: vtUser) {
    try {
      const installmentsMessages =
        await this.prismaService.installmentMessages.findMany({
          where: {
            installmentId: installmentId,
            installments: {
              applicant: {
                userId: user.sub,
              },
            },
          },
        });

      return installmentsMessages;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }
}
