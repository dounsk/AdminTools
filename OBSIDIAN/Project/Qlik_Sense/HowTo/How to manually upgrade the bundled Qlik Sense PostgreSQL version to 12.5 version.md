

Starting at **Qlik Sense Enterprise on Windows May 2021**, the bundled PostgreSQL has been upgraded to version **12.5**.

However, PostgreSQL 12.5 will only be deployed during a fresh installation of Qlik Sense Enterprise on Windows May 2021. This means that, if you are upgrading to Qlik Sense Enterprise on Windows May 2021, PostgreSQL will remain on 9.6.

For many organizations, running on the latest supported PostgreSQL version is a security requirement. To achieve this:

-   [Move Qlik Sense database to standalone PostgresSQL database](https://community.qlik.com/t5/Knowledge-Base/How-to-move-Qlik-Sense-database-to-standalone-PostgresSQL/ta-p/1791775) in which case you will have control of which PostgreSQL version is deployed as long as it is supported by the [system requirements](https://help.qlik.com/en-US/sense-admin/May2021/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/Common/system-requirements.htm)
-   Continue to use the bundled PostgreSQL with version 12.5 (see the process below)

#### **Environment**

-   Qlik Sense Enterprise on Windows May 2021 and later

The information in this article is provided as-is and to be used at your own discretion. Depending on the tool(s) used, customization(s), and/or other factors ongoing support on the solution below may not be provided by Qlik Support.

**This process requires a full reinstallation of the product. Despite the fact that a backup is being taken as part of the process, it is highly recommended to have a second backup plan in place such as a Virtual Machine snapshot and/or a Server Backup.**

**It is highly recommended to test this process in a test environment to get familiar with it.**

## **Step 1: Upgrading your Qlik Sense site**

The first step is to upgrade your environment to Qlik Sense Enterprise on Windows May 2021 following the steps and recommendations provided on this [link.](https://help.qlik.com/en-US/sense-admin/May2021/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/QSEoW/Deploy_QSEoW/Upgrading.htm)

Once the upgrade is done make sure your Qlik Sense site is completely operational.

## **Step 2: Backing up your Qlik Sense site**

At this point, you have an operational Qlik Sense site running on Qlik Sense Enterprise on Windows May 2021, however, the bundled PostgreSQL is still on version 9.6.

The next step will be to backup your entire Qlik Sense site following these [instructions](https://help.qlik.com/en-US/sense-admin/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/QSEoW/Deploy_QSEoW/Backing-up-a-site.htm) (including the certificates) . The backup is essential as it will need to be restored later on.

## **Step 3: Uninstall Qlik Sense on the central node**

You will now need to uninstall Qlik Sense from the **central node** following these [instructions.](https://help.qlik.com/en-US/sense-admin/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/QSEoW/Deploy_QSEoW/Uninstalling.htm)

During the uninstall:

-   Have all rim nodes stopped.
-   **Don't check** the box **Remove Qlik Sense demo apps, certificates, and data folders.**
-   After uninstall and before reinstall rename C:\programdata\qlik to C:\programdata\qlik.old and rename C:\program files\qlik to C:\program files\qlik.old (if you changed it on another drive adjust accordingly)

## **Step 4: Install Qlik Sense Enterprise on Windows May 2021 on the central node**

Now that Qlik Sense Enterprise on Windows May 2021 is uninstalled on the central node, you will reinstall it as a result will deploy a bundled PostgreSQL 12.5. Instructions available [here.](https://help.qlik.com/en-US/sense-admin/May2021/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/QSEoW/Deploy_QSEoW/Installing-Qlik-Sense-Basic.htm)

-   select the same host name and database settings as before
-   The file share can point at a temporary one since you will take the original one again after restoring the QSR database in step 5.

Do not check the box **Start theQlik Senseservices when the setup is complete** at the end of the installer.

## **Step 5: Restoring your Qlik Sense site**

You now have a clean Qlik Sense Enterprise on Windows May 2021 deployed on your central node with PostgreSQL 12.5. You now need to restore your environment to retrieve all your configurations and apps.

Please follow the [Restoring a Qlik Sense site](https://help.qlik.com/en-US/sense-admin/Subsystems/DeployAdministerQSE/Content/Sense_DeployAdminister/QSEoW/Deploy_QSEoW/Restoring-a-site.htm) (including the certificates).

Note: While restoring the database backup you will most likely receive the following error which can be ignored. This error is caused by the version discrepancies between the pg_dump that made the dump file and the pg_restore that's restoring it - in example files coming from PostgreSQL version 9.6 vs files coming from PostgreSQL version 12.5. QSR backup taken and restored with the same version of PostgreSQL will not produce that error.

```markup
pg_restore: while PROCESSING TOC:
pg_restore: from TOC entry 3; 2615 2200 SCHEMA public postgres
pg_restore: error: could not execute query: ERROR:  schema "public" already exists
Command was: CREATE SCHEMA public;


pg_restore: warning: errors ignored on restore: 1
```

Once the environment is restored, you should be able to start your central node and rim nodes successfully.