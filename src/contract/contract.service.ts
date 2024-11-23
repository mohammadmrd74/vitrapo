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
  installmentStatusDto,
} from './dto/createContractInstallment.dto';
import { Prisma } from '@prisma/client';

@Injectable()
export class ContractService {
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
  ) {}
  async getContract(applicantId: number) {
    try {
      const contract = await this.prismaService.contracts.findMany({
        where: {
          applicantId: applicantId,
          applicant: {
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

  async getContractList(applicantId: number, user: vtUser) {
    try {
      const contract = await this.prismaService.contracts.findMany({
        where: {
          applicantId: applicantId,
          applicant: {
            applicantExpert: {
              some: {
                expertId: user.sub,
              },
            },
          },
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
    isUser: boolean,
  ) {
    try {
      //get online currencis
      const currenciesRes = await fetch('https://call2.tgju.org/ajax.json');
      const currencies = await currenciesRes.json();
      const dollarConvert = currencies.current.price_dollar_rl.p
        ? parseInt(currencies.current.price_dollar_rl.p.replace(/,/g, ''), 10)
        : -1;
      const euroConvnert = currencies.current.price_eur.p
        ? parseInt(currencies.current.price_eur.p.replace(/,/g, ''), 10)
        : -1;

      const installments = await this.prismaService.installments.findMany({
        where: {
          applicantId: applicantId,
          contractId: contractId,
          applicant: isUser
            ? {
                userId: user.sub,
                isConfirmed: true,
              }
            : {
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

      return installments.map((ins) => {
        const mainP = ins.price;
        ins.price = new Prisma.Decimal(ins.price).add(
          new Prisma.Decimal(ins.price).mul(0.04),
        );
        let convert = 1;
        switch (ins.priceCurrency) {
          case 'USD':
            convert = dollarConvert;
            break;
          case 'EUR':
            convert = euroConvnert;
            break;
          default:
            convert = -1;
            break;
        }
        return {
          ...ins,
          mainP: mainP,
          convertedPrice: new Prisma.Decimal(ins.price).mul(convert).div(10),
        };
      });
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
      const alreadyUploadedFiles =
        await this.prismaService.installments.findFirst({
          where: {
            id: parseInt(installment.installmentId, 10),
          },
          select: {
            documentFile: true,
          },
        });

      const uploaded_files = await this.minioClientService.uploadMany(
        files,
        'installments',
      );

      const updatedData = Array.isArray(alreadyUploadedFiles.documentFile)
        ? [...alreadyUploadedFiles.documentFile, ...uploaded_files] // Concatenate arrays
        : uploaded_files;
      const updatedInstallment = await this.prismaService.installments.update({
        where: {
          id: parseInt(installment.installmentId, 10),
        },
        data: {
          documentFile: updatedData,
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
  async changeStatusInstallment(body: installmentStatusDto) {
    try {
      const createdContract = await this.prismaService.installments.update({
        data: {
          status: body.status,
        },
        where: {
          id: body.installmentId,
        },
      });

      return createdContract;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async getInstallmentMessage(installmentId: number) {
    try {
      const installmentsMessages =
        await this.prismaService.installmentMessages.findMany({
          where: {
            installmentId: installmentId,
          },
        });

      return installmentsMessages;
    } catch (error) {
      console.log(error);

      throw new NotFoundException();
    }
  }
}
