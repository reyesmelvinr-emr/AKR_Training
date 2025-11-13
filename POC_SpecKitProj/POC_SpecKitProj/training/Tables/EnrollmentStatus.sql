CREATE TABLE [training].[EnrollmentStatus] (
    [StatusId]    TINYINT      NOT NULL,
    [Code]        VARCHAR (32) NOT NULL,
    [DisplayName] VARCHAR (64) NOT NULL,
    PRIMARY KEY CLUSTERED ([StatusId] ASC),
    UNIQUE NONCLUSTERED ([Code] ASC)
);

