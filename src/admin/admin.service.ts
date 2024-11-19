import { Injectable } from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';

@Injectable()
export class AdminService {
  constructor(private prismaService: PrismaService) {}

  async getCountries() {
    return this.prismaService.countries.findMany({
      include: {
        countryTranslation: true,
      },
    });
  }

  async getRoles() {
    return this.prismaService.roles.findMany({
      select: {
        id: true,
        title: true,
      },
    });
  }

  async getUsers(take: number, skip: number, roleId: number) {
    const [users, count] = await this.prismaService.$transaction([
      this.prismaService.users.findMany({
        select: {
          id: true,
          email: true,
          name: true,
          family: true,
          profilePicture: true,
          roleId: true,
          status: true,
          username: true,
          roles: true,
          applicantExpert: {
            include: {
              applicant: true,
            },
          },
          applicant_applicant_sellerIdTousers: {
            include: {
              users: {
                select: {
                  id: true,
                  name: true,
                  family: true,
                },
              },
            },
          },
        },
        where:
          roleId > 0
            ? {
                roleId,
              }
            : {},
        take,
        skip,
      }),
      this.prismaService.users.count({
        where:
          roleId > 0
            ? {
                roleId,
              }
            : {},
      }),
    ]);

    return {
      users,
      count,
      take,
      skip,
    };
  }
}
