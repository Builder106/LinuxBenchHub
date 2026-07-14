module ApplicationHelper
  # Position of x between min and max as a 0–100 percentage, for the ±1σ spread bars.
  def spread_pct(x, min, max)
    (x - min) / (max - min) * 100
  end

  def format_stat(v)
    return "—" unless v.is_a?(Numeric) && v.finite? && v != 0
    return number_with_delimiter(v.round) if v >= 1000
    return format("%.1f", v) if v >= 100
    return format("%.2f", v) if v >= 10
    format("%.3f", v)
  end

  def format_tick(v)
    return number_with_delimiter(v.round) if v >= 1000
    return format("%.0f", v) if v >= 100
    return format("%.1f", v) if v >= 10
    format("%.2f", v)
  end

  FLOW_HEX_R = 56

  def flow_hex_points(r = FLOW_HEX_R)
    [ [ r, 0 ], [ r / 2.0, -r * 0.866 ], [ -r / 2.0, -r * 0.866 ],
     [ -r, 0 ], [ -r / 2.0, r * 0.866 ], [ r / 2.0, r * 0.866 ] ]
      .map { |x, y| format("%.2f,%.2f", x, y) }.join(" ")
  end

  # Line + arrowhead geometry, backing the head off 4px so it doesn't
  # penetrate the target hex.
  def flow_arrow_geometry(x1, y1, x2, y2)
    dx = (x2 - x1).to_f
    dy = (y2 - y1).to_f
    len = Math.sqrt(dx * dx + dy * dy)
    ax = x2 - dx / len * 4
    ay = y2 - dy / len * 4
    { ax: ax.round(2), ay: ay.round(2), angle: (Math.atan2(dy, dx) * 180 / Math::PI).round(2) }
  end
end
