import { Body, Controller, Post, UseGuards } from '@nestjs/common';
import { DocumentService } from './document.service';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import { CreateDocumentDto } from './dto/createDocument.dto';

@Controller('document')
export class DocumentController {
  constructor(private readonly documentService: DocumentService) {}

  @Post('/')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addDocument(@Body() document: CreateDocumentDto) {
    return this.documentService.addDocument(document);
  }
}
