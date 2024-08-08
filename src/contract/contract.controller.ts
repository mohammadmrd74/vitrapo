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
  ParseIntPipe,
  Request
} from '@nestjs/common';
import { ContractService } from './contract.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { CreateContractDto } from './dto/createContract.dto';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';

@Controller('contract')
export class ContractController {
  constructor(private readonly contractService: ContractService) {}

  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  @Post()
  @UseInterceptors(FileInterceptor('image'))
  isertContract(
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
  getContract(
    @Query('applicantId', ParseIntPipe) applicantId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.contractService.getContract(applicantId, req.user);
  }
}
