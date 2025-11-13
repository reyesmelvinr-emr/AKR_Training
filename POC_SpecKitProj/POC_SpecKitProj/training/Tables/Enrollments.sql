CREATE TABLE [training].[Enrollments] (
    [Id]       UNIQUEIDENTIFIER CONSTRAINT [DF_Enrollments_Id] DEFAULT (newsequentialid()) NOT NULL,
    [CourseId] UNIQUEIDENTIFIER NOT NULL,
    [UserId]   UNIQUEIDENTIFIER NOT NULL,
    [Status]   VARCHAR (50)     CONSTRAINT [DF_Enrollments_Status] DEFAULT ('PENDING') NOT NULL,
    CONSTRAINT [PK_Enrollments] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_Enrollments_Status] CHECK ([Status]='CANCELLED' OR [Status]='COMPLETED' OR [Status]='ACTIVE' OR [Status]='PENDING'),
    CONSTRAINT [FK_Enrollments_Course] FOREIGN KEY ([CourseId]) REFERENCES [training].[Courses] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Enrollments_User] FOREIGN KEY ([UserId]) REFERENCES [training].[Users] ([Id]) ON DELETE CASCADE
);




GO



GO
