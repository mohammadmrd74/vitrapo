import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  // Roles — IDs match the frontend's hardcoded checks in useNavbarLinks.ts
  // and ProfilePage.tsx: 1 = applicant/user, 2 = expert, 3 = admin.
  const applicantRole = await prisma.roles.upsert({
    where: { title: 'applicant' },
    update: {},
    create: { id: 1, title: 'applicant' },
  });
  const expertRole = await prisma.roles.upsert({
    where: { title: 'expert' },
    update: {},
    create: { id: 2, title: 'expert' },
  });
  const adminRole = await prisma.roles.upsert({
    where: { title: 'admin' },
    update: {},
    create: { id: 3, title: 'admin' },
  });
  // Extra roles referenced by the register form's role select
  // (همکار, کارشناس مالی, کارشناس دارالترجمه)
  await prisma.roles.upsert({
    where: { title: 'collaborator' },
    update: {},
    create: { id: 4, title: 'collaborator' },
  });
  await prisma.roles.upsert({
    where: { title: 'financial' },
    update: {},
    create: { id: 5, title: 'financial' },
  });
  await prisma.roles.upsert({
    where: { title: 'translator' },
    update: {},
    create: { id: 6, title: 'translator' },
  });

  // Admin user
  await prisma.users.upsert({
    where: { username: 'admin' },
    update: {},
    create: {
      username: 'admin',
      password: await bcrypt.hash('admin123', 10),
      email: 'admin@vitrapo.local',
      mobile: '09120000000',
      name: 'Admin',
      family: 'User',
      roleId: adminRole.id,
      status: 1,
    },
  });

  // Sample applicant user
  await prisma.users.upsert({
    where: { username: 'applicant1' },
    update: {},
    create: {
      username: 'applicant1',
      password: await bcrypt.hash('applicant123', 10),
      email: 'applicant1@vitrapo.local',
      mobile: '09120000001',
      name: 'Sample',
      family: 'Applicant',
      roleId: applicantRole.id,
      status: 1,
    },
  });

  // Student user
  await prisma.users.upsert({
    where: { username: 'student' },
    update: {},
    create: {
      username: 'student',
      password: await bcrypt.hash('student123', 10),
      email: 'student@vitrapo.local',
      mobile: '09120000002',
      name: 'Student',
      family: 'Test',
      roleId: applicantRole.id,
      status: 1,
    },
  });

  // Countries (a handful)
  const countries = [
    { code: 'US', phoneCode: '+1', threeDigitCode: 'USA', name: 'United States' },
    { code: 'CA', phoneCode: '+1', threeDigitCode: 'CAN', name: 'Canada' },
    { code: 'DE', phoneCode: '+49', threeDigitCode: 'DEU', name: 'Germany' },
    { code: 'GB', phoneCode: '+44', threeDigitCode: 'GBR', name: 'United Kingdom' },
    { code: 'AU', phoneCode: '+61', threeDigitCode: 'AUS', name: 'Australia' },
  ];
  for (const c of countries) {
    const existing = await prisma.countries.findFirst({ where: { code: c.code } });
    const country =
      existing ??
      (await prisma.countries.create({
        data: {
          code: c.code,
          phoneCode: c.phoneCode,
          threeDigitCode: c.threeDigitCode,
        },
      }));
    const translation = await prisma.countryTranslation.findFirst({
      where: { countryId: country.id, languageAbbr: 'en' },
    });
    if (!translation) {
      await prisma.countryTranslation.create({
        data: {
          countryId: country.id,
          languageId: 1,
          languageAbbr: 'en',
          name: c.name,
        },
      });
    }
  }

  // Currencies
  for (const cur of [
    { currency: 'USD', convert: 1 },
    { currency: 'EUR', convert: 1 },
    { currency: 'IRR', convert: 50000 },
  ]) {
    const existing = await prisma.currenies.findFirst({
      where: { currency: cur.currency },
    });
    if (!existing) await prisma.currenies.create({ data: cur });
  }

  // Document groups + documents
  const passportGroup = await prisma.doumentGroups.upsert({
    where: { id: 1 },
    update: {},
    create: { id: 1, name: 'Identity' },
  });
  const academicGroup = await prisma.doumentGroups.upsert({
    where: { id: 2 },
    update: {},
    create: { id: 2, name: 'Academic' },
  });
  for (const doc of [
    { docTitle: 'Passport', documentGroupId: passportGroup.id, hasTranslate: 1 },
    { docTitle: 'National ID', documentGroupId: passportGroup.id, hasTranslate: 0 },
    { docTitle: 'Diploma', documentGroupId: academicGroup.id, hasTranslate: 1 },
    { docTitle: 'Transcript', documentGroupId: academicGroup.id, hasTranslate: 1 },
  ]) {
    await prisma.documents.upsert({
      where: { docTitle: doc.docTitle },
      update: {},
      create: doc,
    });
  }

  // Ticket categories
  for (const title of ['General', 'Visa', 'Payment', 'Documents']) {
    await prisma.ticketCategory.upsert({
      where: { title },
      update: {},
      create: { title },
    });
  }

  // Applicant record for the student so ProfilePage has data to render.
  const studentUser = await prisma.users.findUnique({
    where: { username: 'student' },
  });
  const destCountry = await prisma.countries.findFirst({ where: { code: 'DE' } });
  let studentApplicantId: number | null = null;
  if (studentUser && destCountry) {
    let studentApplicant = await prisma.applicant.findFirst({
      where: { userId: studentUser.id },
    });
    if (!studentApplicant) {
      studentApplicant = await prisma.applicant.create({
        data: {
          userId: studentUser.id,
          nationalId: '1234567890',
          destCountryId: destCountry.id,
          visaType: 'education',
          fieldOfStudy: 'Computer Science',
          superVisorMobile: '09120000099',
          studyLanguage: 'en',
          fileNumber: 'STD-0001',
          grade: 'Bachelor',
          telephone: '02100000000',
          state: 'Tehran',
          city: 'Tehran',
          passportNumber: 'A12345678',
          gender: 'male',
          isConfirmed: true,
          isAdminConfirmed: true,
        },
      });
    }
    studentApplicantId = studentApplicant.id;
  }

  // Contract + installments + assigned documents for the student.
  if (studentApplicantId) {
    let contract = await prisma.contracts.findFirst({
      where: { applicantId: studentApplicantId, isMain: 1 },
    });
    if (!contract) {
      contract = await prisma.contracts.create({
        data: {
          applicantId: studentApplicantId,
          title: 'Germany Education Visa',
          description: 'Bachelor degree application — main contract',
          issueDate: new Date(),
          executeDate: new Date(),
          status: 'active',
          totalPrice: 3000,
          istallmetNumbers: 3,
          isMain: 1,
        },
      });
    }

    // Three installments
    const installmentDefs = [
      { num: 1, price: 1000, daysFromNow: 0 },
      { num: 2, price: 1000, daysFromNow: 30 },
      { num: 3, price: 1000, daysFromNow: 60 },
    ];
    for (const def of installmentDefs) {
      const existing = await prisma.installments.findFirst({
        where: {
          contractId: contract.id,
          applicantId: studentApplicantId,
          installmentNumber: def.num,
          isMain: 1,
        },
      });
      if (!existing) {
        const due = new Date();
        due.setDate(due.getDate() + def.daysFromNow);
        await prisma.installments.create({
          data: {
            title: `Installment ${def.num}`,
            contractId: contract.id,
            applicantId: studentApplicantId,
            installmentNumber: def.num,
            price: def.price,
            priceCurrency: 'EUR',
            dueDate: due,
            deadLine: 7,
            isMain: 1,
            status: 'empty',
          },
        });
      }
    }

    // Applicant data group (the "additional info" form on /dashboard).
    let dataGroup = await prisma.applicantDataGroup.findFirst({
      where: { title: 'Personal Background' },
    });
    if (!dataGroup) {
      dataGroup = await prisma.applicantDataGroup.create({
        data: {
          title: 'Personal Background',
          description: 'Additional applicant background information',
          fields: JSON.stringify([
            {
              key: 'fatherName',
              label: 'نام پدر',
              type: 'text',
              validations: { required: true, maxLength: 50 },
              value: '',
              items: [],
            },
            {
              key: 'motherName',
              label: 'نام مادر',
              type: 'text',
              validations: { required: true, maxLength: 50 },
              value: '',
              items: [],
            },
            {
              key: 'birthDate',
              label: 'تاریخ تولد',
              type: 'text',
              validations: { required: true },
              value: '',
              items: [],
            },
            {
              key: 'address',
              label: 'نشانی',
              type: 'text',
              validations: { required: false, maxLength: 200 },
              value: '',
              items: [],
            },
          ]),
        },
      });
    }
    // Link the data group to the student so it appears in their /dashboard
    const existingInfo = await prisma.applicantInformation.findFirst({
      where: {
        applicantId: studentApplicantId,
        contractId: -1,
        dataGroupId: dataGroup.id,
      },
    });
    if (!existingInfo) {
      await prisma.applicantInformation.create({
        data: {
          applicantId: studentApplicantId,
          contractId: -1,
          dataGroupId: dataGroup.id,
          values: JSON.stringify({}),
        },
      });
    }

    // Assign every seeded document to the student's contract
    const allDocs = await prisma.documents.findMany();
    for (const doc of allDocs) {
      const existing = await prisma.applicantContractDocument.findFirst({
        where: {
          applicantId: studentApplicantId,
          contractId: contract.id,
          documentId: doc.id,
        },
      });
      if (!existing) {
        await prisma.applicantContractDocument.create({
          data: {
            applicantId: studentApplicantId,
            contractId: contract.id,
            documentId: doc.id,
            status: 'empty',
            translateStatus: 'empty',
          },
        });
      }
    }
  }

  // Permissions — IDs match the hardcoded switch in
  // Vitrapo-CRM/src/reducers/authReducer.tsx. Path/method are placeholders
  // for the UI flag system; the route-level guard already bypasses admins.
  const permissionDefs: Array<{ id: number; name: string; path: string; method: 'GET' | 'POST' | 'PUT' | 'DELETE' }> = [
    { id: 1,  name: 'canGetUsersList',                       path: '/admin/users',         method: 'GET'  },
    { id: 2,  name: 'canCreateApplicant',                    path: '/applicant',           method: 'POST' },
    { id: 3,  name: 'canCreateContract',                     path: '/contract',            method: 'POST' },
    { id: 4,  name: 'canCreateDataGroup',                    path: '/applicant/datagroup', method: 'POST' },
    { id: 5,  name: 'canAddInstallmentToApplicantsContract', path: '/contract/installment',method: 'POST' },
    { id: 6,  name: 'canCreateDocument',                     path: '/document',            method: 'POST' },
    { id: 7,  name: 'canAddDocumentToApplicant',             path: '/document/applicant',  method: 'POST' },
    { id: 8,  name: 'canAddTicketCategory',                  path: '/ticket/category',     method: 'POST' },
    { id: 9,  name: 'canGetApplicantsList',                  path: '/applicant/list',      method: 'GET'  },
    { id: 10, name: 'canGetApplicantContracts',              path: '/contract',            method: 'GET'  },
    { id: 11, name: 'canGetContractDocuments',               path: '/document',            method: 'GET'  },
    { id: 12, name: 'canChangeDocumentStatus',               path: '/document/changestatus', method: 'PUT' },
    { id: 13, name: 'canAddNotifications',                   path: '/notification',        method: 'POST' },
    { id: 14, name: 'canAddExpertToApplicants',              path: '/applicant/assignexpert', method: 'POST' },
    { id: 15, name: 'canGetContractInstallmentsList',        path: '/contract/installment/list', method: 'GET' },
    { id: 16, name: 'canApproveApplicant',                   path: '/applicant/adminconfirm', method: 'POST' },
    { id: 17, name: 'canGetCountriesList',                   path: '/admin/countries',     method: 'GET'  },
    { id: 18, name: 'canGetRolesList',                       path: '/admin/roles',         method: 'GET'  },
    { id: 19, name: 'canGetAllDocumentsList',                path: '/document/all',        method: 'GET'  },
    { id: 20, name: 'canDeleteApplicantDocuments',           path: '/document/applicant/delete', method: 'POST' },
    { id: 21, name: 'canUnassignApplicantExperts',           path: '/applicant/assignexpert/delete', method: 'POST' },
    { id: 22, name: 'canCreateUser',                         path: '/user/register',       method: 'POST' },
  ];
  for (const p of permissionDefs) {
    await prisma.permissions.upsert({
      where: { id: p.id },
      update: {},
      create: p,
    });
  }

  // Grant permissions per role
  const rolePerms: Record<number, number[]> = {
    [adminRole.id]: permissionDefs.map(p => p.id), // all
    [applicantRole.id]: [10, 11, 15], // own contracts, documents, installments
    [expertRole.id]: [9, 10, 11, 12, 14, 15, 16, 17, 19, 20, 21],
    4: [9, 10, 11, 15, 17, 22],   // collaborator/seller: list applicants & create users under them
    5: [9, 10, 11, 12, 15, 17],   // financial: view installments + change doc status
    6: [9, 11, 12, 17, 19],       // translator: documents focus
  };
  for (const [roleIdStr, ids] of Object.entries(rolePerms)) {
    const roleId = Number(roleIdStr);
    for (const pid of ids) {
      const existing = await prisma.rolePermission_NN.findFirst({
        where: { roleId, permissionId: pid },
      });
      if (!existing) {
        await prisma.rolePermission_NN.create({
          data: { roleId, permissionId: pid, status: 'enabled' },
        });
      }
    }
  }

  console.log('Seed complete. Login: admin / admin123  (SMS code 11111)');
  // Suppress unused warning for expertRole — placeholder for future expert seeds
  void expertRole;
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
