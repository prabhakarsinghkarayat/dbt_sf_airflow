{% macro get_week_start_date(date_column) %}
    date_trunc( 'week', {{date_column}} ) :: date
{% endmacro %}