import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';

import { dbError } from 'src/common/dbError';
import { vtUser } from 'src/auth/authentication.guard';
import { MinioClientService } from 'src/minio-client/minio-client.service';
import { CreateTicketCategoryDto } from './dto/createTicketCategory.dto';
import { CreateTicketDto } from './dto/createTicket.dto';

@Injectable()
export class TicketService {
  constructor(
    private minioClientService: MinioClientService,
    private prismaService: PrismaService,
  ) {}

  async addTicketCategory(category: CreateTicketCategoryDto) {
    try {
      return await this.prismaService.ticketCategory.create({
        data: category,
      });
    } catch (error) {
      dbError(error);

      throw error;
    }
  }

  async insertTicket(
    createTicket: CreateTicketDto,
    files: Array<Express.Multer.File>,
    user: vtUser,
    bucket: string,
  ) {
    try {
      const uploaded_files = await this.minioClientService.uploadMany(
        files,
        bucket,
      );

      const createdTickets = await this.prismaService.tickets.create({
        data: {
          userId: user.sub,
          categoryId: parseInt(createTicket.categoryId, 10),
          title: createTicket.title,
        },
      });

      const createdTicketMessages =
        await this.prismaService.ticketMasseges.create({
          data: {
            userId: user.sub,
            ticketId: createdTickets.id,
            message: createTicket.message,
            files: JSON.stringify(uploaded_files),
          },
        });
      return createdTicketMessages;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }
}
