class Domain < ApplicationRecord

  def self.stack_bar_by_keep(div)
=begin
    find_by_sql(<<-MY_SQL
      SELECT
        DATE_FORMAT(start_date, '%Y %M') as 'year_month',
        SUM(CASE WHEN `empt` = 'Full Time' THEN 1 ELSE 0 END) AS `full_time`,
        SUM(CASE WHEN `empt` = 'Temp' THEN 1 ELSE 0 END) AS `temp`,
        SUM(CASE WHEN `empt` = 'Paid Intern' THEN 1 ELSE 0 END) AS `paid_intern`,
        SUM(CASE WHEN `empt` = 'Unpaid Intern' THEN 1 ELSE 0 END) AS `unpaid_intern`,
        SUM(CASE WHEN `empt` = 'Trainee' THEN 1 ELSE 0 END) AS `trainee`,
        SUM(CASE WHEN `empt` = 'Consultant' THEN 1 ELSE 0 END) AS `consultant`

      FROM on_boardings
      GROUP BY DATE_FORMAT(start_date, '%Y %M')
      ORDER BY start_date
      MY_SQL
    ).map do |row|
      [
        row.year_month,
        row.full_time.to_i,
        row.temp.to_i,
        row.paid_intern.to_i,
        row.unpaid_intern.to_i,
        row.trainee.to_i,
        row.consultant.to_i,
        ''
      ]
    end
=end
  end


end
