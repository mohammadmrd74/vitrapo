import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';
import { dbError } from 'src/common/dbError';
import { vtUser } from 'src/auth/authentication.guard';
import { MinioClientService } from 'src/minio-client/minio-client.service';
import { CreateTicketCategoryDto } from './dto/createTicketCategory.dto';
import {
  CreateTicketDto,
  CreateTicketMessageDto,
} from './dto/createTicket.dto';
import { Prisma } from '@prisma/client';

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

  async getTicketCategory() {
    try {
      return await this.prismaService.ticketCategory.findMany();
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

      const data: Prisma.ticketsUncheckedCreateInput = {
        userId: user.sub,
        categoryId: parseInt(createTicket.categoryId, 10),
        title: createTicket.title,
        ticketMasseges: {
          create: {
            userId: user.sub,
            message: createTicket.message,
            files: uploaded_files,
          },
        },
      };

      if (createTicket.expertIds && JSON.parse(createTicket.expertIds)) {
        data.ticketExpert = {
          createMany: {
            data: JSON.parse(createTicket.expertIds).map((ex) => ({
              expertId: ex,
            })),
          },
        };
      }

      const createdTickets = await this.prismaService.tickets.create({
        data: data,
      });

      return createdTickets;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async replyTicket(
    createTicketReply: CreateTicketMessageDto,
    files: Array<Express.Multer.File>,
    user: vtUser,
    bucket: string,
  ) {
    try {
      const uploaded_files = await this.minioClientService.uploadMany(
        files,
        bucket,
      );

      const createdTicketReplies =
        await this.prismaService.ticketMasseges.create({
          data: {
            userId: user.sub,
            ticketId: parseInt(createTicketReply.ticketId, 10),
            message: createTicketReply.message,
            files: uploaded_files,
          },
        });

      return createdTicketReplies;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async getAllTickets(user: vtUser, take: number, skip: number) {
    try {
      const [tickets, count] = await this.prismaService.$transaction([
        this.prismaService.tickets.findMany({
          where: {
            OR: [
              {
                userId: user.sub,
              },
              {
                users: {
                  applicant: {
                    some: {
                      applicantExpert: {
                        some: {
                          expertId: user.sub,
                        },
                      },
                    },
                  },
                },
              },
              {
                ticketExpert: {
                  some: {
                    expertId: user.sub,
                  },
                },
              },
            ],
          },
          include: {
            ticketCategory: true,
            users: {
              select: {
                name: true,
                family: true,
              },
            },
          },
          take: take,
          skip: skip,
        }),
        this.prismaService.tickets.count({
          where: {
            OR: [
              {
                userId: user.sub,
              },
              {
                users: {
                  applicant: {
                    some: {
                      applicantExpert: {
                        some: {
                          expertId: user.sub,
                        },
                      },
                    },
                  },
                },
              },
              {
                ticketExpert: {
                  some: {
                    expertId: user.sub,
                  },
                },
              },
            ],
          },
        }),
      ]);

      return {
        tickets,
        count,
        take,
        skip,
      };
    } catch (error) {
      dbError(error);

      throw error;
    }
  }
  async getTicketReplies(user: vtUser, ticketId) {
    try {
      const replies = await this.prismaService.ticketMasseges.findMany({
        where: {
          // userId: user.sub,
          ticketId,
        },
      });

      return replies;
    } catch (error) {
      dbError(error);

      throw error;
    }
  }
}
