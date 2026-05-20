export function TuxMark({
  size = 20,
  className,
}: {
  size?: number;
  className?: string;
}) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 22 22"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
      aria-hidden="true"
    >
      <circle cx="11" cy="11" r="10.5" fill="#fbf0e8" />
      <ellipse cx="11" cy="12" rx="7" ry="8" fill="#0e0e10" />
      <circle cx="8" cy="9.5" r="1.5" fill="#fbf0e8" />
      <circle cx="14" cy="9.5" r="1.5" fill="#fbf0e8" />
      <circle cx="8.4" cy="9.7" r="0.7" fill="#0a0507" />
      <circle cx="13.6" cy="9.7" r="0.7" fill="#0a0507" />
      <polygon points="9,12.6 13,12.6 11,15.4" fill="#e8a020" />
    </svg>
  );
}
