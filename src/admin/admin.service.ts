import { Injectable } from '@nestjs/common';
import { vtUser } from 'src/auth/authentication.guard';
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
    const groups = await this.prismaService.applicantDataGroup.findMany();
    return groups.map(g => ({
      ...g,
      fields: g.fields ? JSON.parse(g.fields) : [],
    }));
  }

  async deleteDG(id: number) {
    return this.prismaService.applicantDataGroup.delete({
      where: {
        id,
      },
    });
  }
  async deletUser(id: number) {
    return this.prismaService.users.update({
      data: {
        status: 0,
      },
      where: {
        id,
      },
    });
  }

  async getUsers(take: number, skip: number, roleId: number, user: vtUser) {
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
          user.roleId === 3
            ? roleId > 0
              ? {
                  roleId,
                }
              : {}
            : roleId > 0
              ? {
                  roleId,
                  masterId: user.sub,
                }
              : {
                  masterId: user.sub,
                },
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
  async getSingleUser(id: number) {
    const [users] = await this.prismaService.$transaction([
      this.prismaService.users.findFirst({
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
        where: {
          id,
        },
      }),
    ]);

    return {
      users,
    };
  }
}
