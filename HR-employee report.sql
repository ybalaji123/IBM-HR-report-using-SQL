use IBM_EMPLOYEE

select * from [dbo].[IBM HR data]


ALTER PROCEDURE [dbo].[HR_employee_report]
    @EmployeeNumber INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @Age INT,
        @Education INT,
        @Department NVARCHAR(100),
        @JobRole NVARCHAR(100),
        @MonthlyIncome INT,
        @PerformanceRating INT,
        @EnvironmentSatisfaction INT,
        @Attrition NVARCHAR(10),
        @OverTime NVARCHAR(10),
        @JobSatisfaction INT,
        @EmployeeName NVARCHAR(100) = 'Praveen S', -- Replace if column exists
        @TotalActions INT,
        @RoleChanges INT = 1,
        @SalaryCredits INT,
        @PerformanceReviews INT,
        @OtherUpdates INT = 1,
        @Risk1 NVARCHAR(100) = '',
        @Risk2 NVARCHAR(100) = '',
        @Risk3 NVARCHAR(100) = '';

    -- Fetch employee details
    SELECT 
        @Age = Age,
        @Education = Education,
        @Department = Department,
        @JobRole = JobRole,
        @MonthlyIncome = MonthlyIncome,
        @PerformanceRating = PerformanceRating,
        @EnvironmentSatisfaction = EnvironmentSatisfaction,
        @Attrition = Attrition,
        @OverTime = OverTime,
        @JobSatisfaction = JobSatisfaction
    FROM [dbo].[IBM HR data]
    WHERE EmployeeNumber = @EmployeeNumber;

    -- HR Actions logic
    SET @PerformanceReviews = CASE WHEN @PerformanceRating IS NOT NULL THEN 1 ELSE 0 END;
    SET @SalaryCredits = CASE WHEN @MonthlyIncome > 0 THEN 1 ELSE 0 END;
    SET @TotalActions = @RoleChanges + @SalaryCredits + @PerformanceReviews + @OtherUpdates;

    -- Determine risk flags
    IF @JobSatisfaction < 3
        SET @Risk1 = '        May 5, 2020 - Low Job Satisfaction';

    IF @OverTime = 'Yes'
        SET @Risk2 = '        May 12, 2020 - OverTime Logged';

    IF @EnvironmentSatisfaction < 3
        SET @Risk3 = '        May 22, 2020 - Environment Score: ' + CAST(@EnvironmentSatisfaction AS NVARCHAR);

    -- Output report
    PRINT REPLICATE('-', 92);
    PRINT '                                      HR EMPLOYEE REPORT';
    PRINT '                Employee Activity Summary – Report for Employee No: ' + CAST(@EmployeeNumber AS NVARCHAR);
    PRINT REPLICATE('-', 92);
    PRINT 'Product Name   : HRMS';
    PRINT 'Employee No.   : ' + CAST(@EmployeeNumber AS NVARCHAR) + '                             Department     : ' + @Department;
    PRINT 'Employee Name  : ' + @EmployeeName + '                     Cleared Status : Attrition - ' + @Attrition;
    PRINT '';
    PRINT 'SL.NO   DATE         ACTION TYPE         DETAILS                     VALUE      STATUS';
    PRINT '1       -            Joined              Age: ' + CAST(@Age AS NVARCHAR) + ', Education: ' + CAST(@Education AS NVARCHAR) + '       -          Active';
    PRINT '2       -            Assigned Role       Job Role: ' + @JobRole + '   -          Ongoing';
    PRINT '3       -            Salary Credited     MonthlyIncome: ₹' + CAST(@MonthlyIncome AS NVARCHAR) + '        -          Credited';
    PRINT '4       -            Performance         Rating: ' + CAST(@PerformanceRating AS NVARCHAR) + '                   -          Satisfactory';
    PRINT '';
    PRINT 'Total Number of HR Actions       : ' + CAST(@TotalActions AS NVARCHAR);
    PRINT '        Role Changes             : ' + CAST(@RoleChanges AS NVARCHAR);
    PRINT '        Salary Credits           : ' + CAST(@SalaryCredits AS NVARCHAR);
    PRINT '        Performance Reviews      : ' + CAST(@PerformanceReviews AS NVARCHAR);
    PRINT '        Other Updates            : ' + CAST(@OtherUpdates AS NVARCHAR);
    PRINT '';
    PRINT 'Dates When Attrition Risk Increased:';
    IF LEN(@Risk1) > 0 PRINT @Risk1;
    IF LEN(@Risk2) > 0 PRINT @Risk2;
    IF LEN(@Risk3) > 0 PRINT @Risk3;
    IF LEN(@Risk1 + @Risk2 + @Risk3) = 0 PRINT '        No significant risk events recorded.';
    PRINT '';
    PRINT 'Closing Status: Attrition - ' + @Attrition;
    PRINT REPLICATE('-', 92);
END;


exec HR_employee_report  @EmployeeNumber =1