import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import { CreateDocumentDto } from './dto/createDocument.dto';
import { dbError } from 'src/common/dbError';

@Injectable()
export class DocumentService {
  constructor(private prismaService: PrismaService) {}

  async addDocument(document: CreateDocumentDto) {
    if (document.documentGroupId) {
      try {
        return await this.prismaService.documents.create({
          data: document,
        });
      } catch (error) {
        dbError(error);

        throw error;
      }
    } else if (document.documentGroupTitle && !document.documentGroupId) {
      try {
        return await this.prismaService.documents.create({
          data: {
            docTitle: document.docTitle,
            docDescription: document.docDescription,
            doumentGroups: {
              create: {
                name: document.documentGroupTitle,
              },
            },
          },
        });
      } catch (error) {
        console.log(error);
        
        dbError(error);

        throw error;
      }
    } else {
      throw new Error(
        'Either documentGroupId or documentGroupTitle must be provided',
      );
    }
  }
}
