import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { PrismaService } from 'src/database/prisma.service';

@Injectable()
export class AuthorizationGuard implements CanActivate {
  constructor(private prismaService: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();

    try {
      if (!request.user.sub) throw new UnauthorizedException();

      const user = await this.prismaService.users.findUnique({
        where: { id: request.user.sub },
        select: { roles: { select: { title: true } } },
      });
      if (user?.roles?.title === 'admin') return true;

      const rolePermissionIds =
        await this.prismaService.rolePermission_NN.findFirst({
          where: {
            permissions: {
              path: request.route.path,
              method: request.method,
            },
            roles: {
              users: {
                some: {
                  id: request.user.sub,
                },
              },
            },
          },
          select: {
            id: true,
          },
        });

      if (!rolePermissionIds) throw new UnauthorizedException();

      // const canAccess = await this.prismaService
      //   .$queryRaw`call canAccess(${request.url}, ${request.method}, ${payload.sub})`;
    } catch {
      throw new UnauthorizedException();
    }
    return true;
  }
}
