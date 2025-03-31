WITH RECURSIVE Subordinates AS (
    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        d.departmentid,
        r.RoleName
    FROM Employees e
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN Roles r ON e.RoleID = r.RoleID
    WHERE e.EmployeeID = 1

    UNION ALL

    SELECT
        e.EmployeeID,
        e.Name AS EmployeeName,
        e.ManagerID,
        d.DepartmentName,
        d.departmentid,
        r.RoleName
    FROM Employees e
    INNER JOIN Subordinates s ON e.ManagerID = s.EmployeeID
    LEFT JOIN Departments d ON e.DepartmentID = d.DepartmentID
    LEFT JOIN Roles r ON e.RoleID = r.RoleID
)

SELECT
    s.EmployeeID,
    s.EmployeeName,
    s.ManagerID,
    s.DepartmentName,
    s.RoleName,
    COALESCE(string_agg(DISTINCT p.ProjectName, ', '), 'NULL') AS ProjectNames,
    COALESCE(string_agg(DISTINCT t.TaskName, ', '), 'NULL') AS TaskNames
FROM Subordinates s
LEFT JOIN Projects p ON s.DepartmentID = p.DepartmentID
LEFT JOIN Tasks t ON s.EmployeeID = t.AssignedTo
GROUP BY s.EmployeeID, s.EmployeeName, s.ManagerID, s.DepartmentName, s.RoleName
ORDER BY s.EmployeeName;

