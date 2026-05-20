import { HexMark } from "./HexMark";
import { TuxMark } from "./TuxMark";

export function FacetDivider() {
  return (
    <div className="facet-divider" aria-hidden="true">
      <svg width="140" height="14" viewBox="0 0 140 14">
        <line
          x1="8"
          y1="11"
          x2="30"
          y2="3"
          stroke="var(--accent-dim)"
          strokeWidth="1.2"
          strokeLinecap="round"
        />
        <line
          x1="58"
          y1="11"
          x2="82"
          y2="3"
          stroke="var(--accent)"
          strokeWidth="1.2"
          strokeLinecap="round"
        />
        <line
          x1="110"
          y1="11"
          x2="132"
          y2="3"
          stroke="var(--accent-dim)"
          strokeWidth="1.2"
          strokeLinecap="round"
        />
      </svg>
    </div>
  );
}

export function SectionFlag({
  children,
  withTux = false,
}: {
  children: React.ReactNode;
  withTux?: boolean;
}) {
  return (
    <div className="section-flag">
      <HexMark size={18} />
      {withTux && <TuxMark size={18} />}
      <h2>{children}</h2>
    </div>
  );
}
