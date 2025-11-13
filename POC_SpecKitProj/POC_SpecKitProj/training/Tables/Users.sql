CREATE TABLE [training].[Users] (
    [Id]        UNIQUEIDENTIFIER CONSTRAINT [DF_Users_Id] DEFAULT (newsequentialid()) NOT NULL,
    [Email]     VARCHAR (256)    NOT NULL,
    [FirstName] VARCHAR (128)    NOT NULL,
    [LastName]  VARCHAR (128)    NOT NULL,
    [IsActive]  BIT              CONSTRAINT [DF_Users_IsActive] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_Users_Email] CHECK ([Email] like '%@%.%'),
    CONSTRAINT [UQ_Users_Email] UNIQUE NONCLUSTERED ([Email] ASC)
);

