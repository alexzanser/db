WITH RECURSIVE ManagerHierarchy AS (
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN Roles r ON e.RoleID = r.RoleID
    WHERE r.RoleName = 'Менеджер'
    UNION ALL
    SELECT e.EmployeeID, e.Name, e.ManagerID, e.DepartmentID, e.RoleID
    FROM Employees e
    INNER JOIN ManagerHierarchy mh ON e.ManagerID = mh.EmployeeID
)
SELECT
    mh.EmployeeID,
    mh.Name AS EmployeeName,
    mh.ManagerID,
    d.DepartmentName,
    r.RoleName,
    COALESCE(STRING_AGG(DISTINCT p.ProjectName, ', ' ORDER BY p.ProjectName), NULL) AS ProjectNames,
    COALESCE(STRING_AGG(DISTINCT t.TaskName, ', ' ORDER BY t.TaskName), NULL) AS TaskNames,
    COUNT(DISTINCT sub.EmployeeID) AS TotalSubordinates
FROM ManagerHierarchy mh
LEFT JOIN Departments d ON mh.DepartmentID = d.DepartmentID
LEFT JOIN Roles r ON mh.RoleID = r.RoleID
LEFT JOIN Projects p ON p.DepartmentID = mh.DepartmentID
LEFT JOIN Tasks t ON t.AssignedTo = mh.EmployeeID
LEFT JOIN Employees sub ON mh.EmployeeID = sub.ManagerID
GROUP BY mh.EmployeeID, mh.Name, mh.ManagerID, d.DepartmentName, r.RoleName
HAVING COUNT(DISTINCT sub.EmployeeID) > 0
ORDER BY mh.Name;

