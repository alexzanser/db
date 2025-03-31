WITH RECURSIVE EmployeeHierarchy AS (
    -- Базовый случай: Находим всех сотрудников, чьим менеджером является Иван Иванов (EmployeeID = 1)
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    WHERE e.ManagerID = 1

    UNION ALL

    -- Рекурсивное объединение: Ищем подчиненных подчиненных
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        e.DepartmentID,
        e.RoleID
    FROM Employees e
    INNER JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
SELECT
    eh.EmployeeID,
    eh.EmployeeName,
    eh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    COALESCE(string_agg(DISTINCT p.ProjectName, ', '), 'NULL') AS ProjectNames,
    COALESCE(string_agg(DISTINCT t.TaskName, ', '), 'NULL') AS TaskNames
FROM EmployeeHierarchy eh
LEFT JOIN Departments d ON eh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON eh.RoleID = r.RoleID
LEFT JOIN Projects p ON p.DepartmentID = eh.DepartmentID
LEFT JOIN Tasks t ON t.AssignedTo = eh.EmployeeID
GROUP BY eh.EmployeeID, eh.EmployeeName, eh.ManagerID, d.DepartmentName, r.RoleName
ORDER BY eh.EmployeeName;

