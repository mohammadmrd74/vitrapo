import {
  Body,
  Controller,
  Get,
  ParseIntPipe,
  Post,
  Query,
  Request,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { TicketService } from './ticket.service';
import {
  AnyFilesInterceptor,
  FileFieldsInterceptor,
} from '@nestjs/platform-express';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import { CreateTicketDto } from './dto/createTicket.dto';
import { CreateTicketCategoryDto } from './dto/createTicketCategory.dto';
import { FilesValidationPipe } from 'src/common/validationPipes/fileValidationPipe';

@Controller('ticket')
export class TicketController {
  constructor(private readonly ticketService: TicketService) {}

  @Post('/category')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addDocument(@Body() document: CreateTicketCategoryDto) {
    return this.ticketService.addTicketCategory(document);
  }

  // @Post('/applicant')
  // @UseGuards(AuthenticationGuard, AuthorizationGuard)
  // addDocumentForApplicant(@Body() body: CreateApplicantDocumentDto) {
  //   return this.documentService.addDocumentForApplicant(body);
  // }

  // @Get('/')
  // @UseGuards(AuthenticationGuard)
  // getDocument(
  //   @Query('applicantId', ParseIntPipe) applicantId: number,
  //   @Query('contractId', ParseIntPipe) contractId: number,
  //   @Request() req: Request & { user: vtUser },
  // ) {
  //   return this.documentService.getDocument(applicantId, contractId, req.user);
  // }

  @UseGuards(AuthenticationGuard)
  @Post('/')
  @UseInterceptors(AnyFilesInterceptor())
  insertContractApplicantDocument(
    @Body() body: CreateTicketDto,
    @UploadedFiles(new FilesValidationPipe())
    files: Array<Express.Multer.File>,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.ticketService.insertTicket(body, files, req.user, 'tickets');
  }

  // @UseGuards(AuthenticationGuard)
  // @Post('/message')
  // insertContractApplicantMessage(
  //   @Body() body: CreateContractApplicantDocumenMessageDto,

  //   @Request() req: Request & { user: vtUser },
  // ) {
  //   return this.documentService.insertContractApplicantMessage(body, req.user);
  // }

  // @UseGuards(AuthenticationGuard)
  // @Get('/message')
  // getContractApplicantMessage(
  //   @Query('applicantContractDocumentId', ParseIntPipe)
  //   applicantContractDocumentId: number,
  // ) {
  //   return this.documentService.getContractApplicantMessage(
  //     applicantContractDocumentId,
  //   );
  // }
}
