import { Injectable } from '@nestjs/common';
import { vtUser } from 'src/auth/authentication.guard';
import { PrismaService } from 'src/database/prisma.service';
import { CreateNotificationDto } from './dto/notification.dto';
import { dbError } from 'src/common/dbError';

@Injectable()
export class NotificationService {
  constructor(private prismaService: PrismaService) {}

  async insertNotification(notification: CreateNotificationDto) {
    try {
      let uNotification;
      if (notification.userId) {
        uNotification = await this.prismaService.notification.create({
          data: {
            title: notification.title,
            text: notification.text,
            userNotification_NN: {
              create: {
                userId: notification.userId,
              },
            },
          },
        });
      } else {
        uNotification = await this.prismaService.$transaction(async (tx) => {
          const userIds = await tx.users.findMany({
            select: {
              id: true,
            },
          });
          const cn = await tx.notification.create({
            data: {
              title: notification.title,
              text: notification.text,
              isIndividual: false,
              userNotification_NN: {
                createMany: {
                  data: userIds.map((u) => ({
                    userId: u.id,
                  })),
                },
              },
            },
          });

          return cn;
        });
      }

      return uNotification;
    } catch (error) {
      console.log(error);
      dbError(error);

      throw error;
    }
  }

  async readNotification(allNotifIds: Array<number>, userId: number) {
    try {
      const requests = [];
      for (const n of allNotifIds) {
        requests.push(
          this.prismaService.userNotification_NN.upsert({
            where: {
              userId_notificationId: {
                userId: userId,
                notificationId: n,
              },
            },
            update: {
              isRead: true,
            },
            create: {
              userId: userId,
              notificationId: n,
              isRead: true,
            },
          }),
        );
      }

      await Promise.all(requests);
    } catch (error) {
      throw dbError(error);
    }
  }

  async getNotifications(user: vtUser, take: number, skip: number) {
    try {
      const [allNotifcations, count] = await this.prismaService.$transaction([
        this.prismaService.userNotification_NN.findMany({
          where: {
            userId: user.sub,
          },
          select: {
            notification: {
              select: {
                id: true,
                title: true,
                text: true,
                isIndividual: true,
              },
            },
            isRead: true,
            createdAt: true,
          },
          take: take,
          skip: skip,
        }),
        this.prismaService.userNotification_NN.count({
          where: {
            userId: user.sub,
          },
        }),
      ]);

      const allNotifIds: Array<number> = allNotifcations.map(
        (n) => n.notification.id,
      );

      console.log('allNotifIds', allNotifIds);

      this.readNotification(allNotifIds, user.sub);

      return {
        notifications: allNotifcations,
        count: count,
        skip: skip,
        take: take,
      };
    } catch (error) {
      throw dbError(error);
    }
  }
}
