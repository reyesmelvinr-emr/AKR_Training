CREATE TABLE [training].[Courses] (
    [Id]             UNIQUEIDENTIFIER CONSTRAINT [DF_Courses_Id] DEFAULT (newsequentialid()) NOT NULL,
    [Title]          VARCHAR (200)    NOT NULL,
    [Description]    NVARCHAR (MAX)   NULL,
    [IsRequired]     BIT              CONSTRAINT [DF_Courses_IsRequired] DEFAULT ((0)) NOT NULL,
    [IsActive]       BIT              CONSTRAINT [DF_Courses_IsActive] DEFAULT ((1)) NOT NULL,
    [ValidityMonths] INT              NULL,
    [Category]       VARCHAR (100)    NULL,
    CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_Courses_Title_NotEmpty] CHECK (len(ltrim(rtrim([Title])))>(0))
);




GO
