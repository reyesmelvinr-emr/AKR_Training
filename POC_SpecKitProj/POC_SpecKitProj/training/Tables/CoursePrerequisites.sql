CREATE TABLE [training].[CoursePrerequisites] (
    [CourseId]       UNIQUEIDENTIFIER NOT NULL,
    [PrerequisiteId] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_CoursePrerequisites] PRIMARY KEY CLUSTERED ([CourseId] ASC, [PrerequisiteId] ASC),
    CONSTRAINT [CK_CoursePrereq_NoSelfRef] CHECK ([CourseId]<>[PrerequisiteId]),
    CONSTRAINT [FK_CoursePrereq_Course] FOREIGN KEY ([CourseId]) REFERENCES [training].[Courses] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_CoursePrereq_Prereq] FOREIGN KEY ([PrerequisiteId]) REFERENCES [training].[Courses] ([Id])
);

