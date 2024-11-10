import {
  Controller,
  Post,
  Body,
  ParseFilePipe,
  UploadedFile,
  MaxFileSizeValidator,
  FileTypeValidator,
  UseInterceptors,
  UseGuards,
  Query,
  Get,
  Put,
  ParseIntPipe,
  Request,
  UploadedFiles,
} from '@nestjs/common';
import { ContractService } from './contract.service';
import { FileInterceptor, FilesInterceptor } from '@nestjs/platform-express';
import { CreateContractDto } from './dto/createContract.dto';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import {
  CreateContractInstallmentDto,
  CreateContractInstallmentFileDto,
  CreateInstallmentMessageDto,
} from './dto/createContractInstallment.dto';
import { FilesValidationPipe } from 'src/common/validationPipes/fileValidationPipe';

@Controller('contract')
export class ContractController {
  constructor(private readonly contractService: ContractService) {}

  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  @Post()
  @UseInterceptors(FileInterceptor('image'))
  insertContract(
    @Body() createContract: CreateContractDto,
    @UploadedFile(
      new ParseFilePipe({
        validators: [
          new MaxFileSizeValidator({
            maxSize: 500000,
            message: 'size should be less than 500kb',
          }),
          new FileTypeValidator({ fileType: 'image/jpeg|image/png' }),
        ],
      }),
    )
    file: Express.Multer.File,
  ) {
    return this.contractService.insertContract(
      createContract,
      file,
      'contracts',
    );
  }

  @UseGuards(AuthenticationGuard)
  @Get()
  getContract(@Query('applicantId', ParseIntPipe) applicantId: number) {
    return this.contractService.getContract(applicantId);
  }

  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  @Get('/list')
  getContractList(
    @Query('applicantId', ParseIntPipe) applicantId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.contractService.getContractList(applicantId, req.user);
  }

  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  @Post('/installment')
  insertContractInstallment(
    @Body() createContractInstallment: CreateContractInstallmentDto,
  ) {
    return this.contractService.insertContractInstallment(
      createContractInstallment,
    );
  }

  @UseGuards(AuthenticationGuard)
  @Put('/installment/file')
  @UseInterceptors(FilesInterceptor('files'))
  insertInstallmentFile(
    @Body() createInstallmentFile: CreateContractInstallmentFileDto,
    @UploadedFiles(new FilesValidationPipe())
    files: Array<Express.Multer.File>,
  ) {
    return this.contractService.insertInstallmentFile(
      createInstallmentFile,
      files,
    );
  }

  @UseGuards(AuthenticationGuard)
  @Get('/installment')
  getContractInstallment(
    @Query('applicantId', ParseIntPipe) applicantId: number,
    @Query('contractId', ParseIntPipe) contractId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.contractService.getContractInstallments(
      applicantId,
      contractId,
      req.user,
    );
  }

  @UseGuards(AuthenticationGuard)
  @Post('/installment/message')
  insertInstallmentMessage(
    @Body() installmentMessage: CreateInstallmentMessageDto,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.contractService.insertInstallmentMessage(
      installmentMessage,
      req.user,
    );
  }

  @UseGuards(AuthenticationGuard)
  @Get('/installment/message')
  getInstallmentMessage(
    @Query('installmentId', ParseIntPipe) installmentId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.contractService.getInstallmentMessage(installmentId, req.user);
  }
}
