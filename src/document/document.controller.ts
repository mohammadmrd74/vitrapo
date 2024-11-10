import {
  Body,
  Controller,
  Get,
  ParseIntPipe,
  Post,
  Put,
  Query,
  Request,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { DocumentService } from './document.service';
import { FileFieldsInterceptor } from '@nestjs/platform-express';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import {
  ChangeStatusDocumentDto,
  CreateApplicantDocumentDto,
  CreateContractApplicantDocumenFileDto,
  CreateContractApplicantDocumenMessageDto,
  CreateDocumentDto,
} from './dto/createDocument.dto';
import { FilesValidationPipe } from 'src/common/validationPipes/fileValidationPipe';

@Controller('document')
export class DocumentController {
  constructor(private readonly documentService: DocumentService) {}

  @Post('/')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addDocument(@Body() document: CreateDocumentDto) {
    return this.documentService.addDocument(document);
  }

  @Put('/changestatus')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  changeStatus(@Body() document: ChangeStatusDocumentDto) {
    return this.documentService.changeStatus(document);
  }

  @Post('/applicant')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addDocumentForApplicant(@Body() body: CreateApplicantDocumentDto) {
    return this.documentService.addDocumentForApplicant(body);
  }

  @Get('/')
  @UseGuards(AuthenticationGuard)
  getDocument(
    @Query('applicantId', ParseIntPipe) applicantId: number,
    @Query('contractId', ParseIntPipe) contractId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.documentService.getDocument(
      applicantId,
      contractId,
      true,
      req.user,
    );
  }

  @Get('/list')
  @UseGuards(AuthenticationGuard)
  getDocumentList(
    @Query('applicantId', ParseIntPipe) applicantId: number,
    @Query('contractId', ParseIntPipe) contractId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.documentService.getDocument(
      applicantId,
      contractId,
      true,
      req.user,
    );
  }

  @UseGuards(AuthenticationGuard)
  @Post('/file')
  @UseInterceptors(
    FileFieldsInterceptor([
      { name: 'original', maxCount: 1 },
      { name: 'translate', maxCount: 1 },
    ]),
  )
  insertContractApplicantDocument(
    @Body() body: CreateContractApplicantDocumenFileDto,
    @UploadedFiles(new FilesValidationPipe())
    files: {
      original?: Express.Multer.File[];
      translate?: Express.Multer.File[];
    },
  ) {
    return this.documentService.insertContractApplicantDocument(body, files);
  }

  @UseGuards(AuthenticationGuard)
  @Post('/message')
  insertContractApplicantMessage(
    @Body() body: CreateContractApplicantDocumenMessageDto,

    @Request() req: Request & { user: vtUser },
  ) {
    return this.documentService.insertContractApplicantMessage(body, req.user);
  }

  @UseGuards(AuthenticationGuard)
  @Get('/message')
  getContractApplicantMessage(
    @Query('applicantContractDocumentId', ParseIntPipe)
    applicantContractDocumentId: number,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.documentService.getContractApplicantMessage(
      applicantContractDocumentId,
      req.user,
    );
  }
}
