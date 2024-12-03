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

  async getAllDG() {
    return this.prismaService.applicantDataGroup.findMany();
  }

  async deleteDG(id: number) {
    return this.prismaService.applicantDataGroup.delete({
      where: {
        id,
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
          createdAt: true,
          applicantExpert: {
            include: {
              applicant: true,
            },
          },
          applicant_applicant_sellerIdTousers: {
            include: {
              applicantExpert: {
                select: {
                  expertId: true,
                  users: {
                    select: {
                      name: true,
                      family: true,
                    },
                  },
                  applicant: true,
                },
              },
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
