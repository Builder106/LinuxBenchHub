module ShowcaseHelper
  FLOWCHART_HEX_RADIUS = 56

  def showcase_hex_points(r = FLOWCHART_HEX_RADIUS)
    [ [ r, 0 ], [ r / 2.0, -r * 0.866 ], [ -r / 2.0, -r * 0.866 ],
     [ -r, 0 ], [ -r / 2.0, r * 0.866 ], [ r / 2.0, r * 0.866 ] ]
      .map { |x, y| "#{'%.2f' % x},#{'%.2f' % y}" }.join(" ")
  end

  # Endpoint + rotation for a flowchart arrow, backed off so the head
  # doesn't penetrate the target hex, mirroring the old FlowArrow component.
  def showcase_flow_arrow(x1:, y1:, x2:, y2:)
    dx = x2 - x1
    dy = y2 - y1
    len = Math.sqrt((dx * dx) + (dy * dy))
    ux = dx / len
    uy = dy / len
    {
      ax: x2 - (ux * 4),
      ay: y2 - (uy * 4),
      angle: Math.atan2(dy, dx) * 180 / Math::PI,
      mx: (x1 + x2) / 2.0,
      my: ((y1 + y2) / 2.0) - 6
    }
  end

  def showcase_pct(x, min, max)
    ((x - min) / (max - min).to_f) * 100
  end

  def showcase_format_tick(v)
    return number_with_delimiter(v.round) if v >= 1000
    return format("%.0f", v) if v >= 100
    return format("%.1f", v) if v >= 10

    format("%.2f", v)
  end

  def showcase_format_stat(v)
    return "—" if !v.finite? || v.zero?
    return number_with_delimiter(v.round) if v >= 1000
    return format("%.1f", v) if v >= 100
    return format("%.2f", v) if v >= 10

    format("%.3f", v)
  end

  def showcase_spec_value(pairs, key)
    pairs.find { |pair| pair[:key] == key }&.dig(:value)
  end

  def showcase_hardware_summary(hardware, software)
    processor = showcase_spec_value(hardware, "Processor")
    memory = showcase_spec_value(hardware, "Memory")
    disk = showcase_spec_value(hardware, "Disk")
    layer = showcase_spec_value(software, "System Layer")

    parts = [ processor, (memory && "#{memory} RAM"), disk ].compact
    summary = parts.join(", ")
    layer ? "#{summary}, via #{layer}" : summary
  end

  def showcase_run_count_label(tests)
    counts = tests.map { |t| t[:runs].length }.uniq.sort
    counts.length == 1 ? counts.first.to_s : "#{counts.first} to #{counts.last}"
  end
end
