CREATE VIEW training.vw_CourseEnrollmentSummary AS
SELECT c.Id AS CourseId,
       c.Title,
       Total = COUNT(e.Id),
       ActiveCount = SUM(CASE WHEN e.Status = 'ACTIVE' THEN 1 ELSE 0 END),
       CompletedCount = SUM(CASE WHEN e.Status = 'COMPLETED' THEN 1 ELSE 0 END)
FROM training.Courses c
LEFT JOIN training.Enrollments e ON c.Id = e.CourseId
GROUP BY c.Id, c.Title;