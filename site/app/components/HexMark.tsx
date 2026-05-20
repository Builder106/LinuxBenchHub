export function HexMark({
  size = 22,
  className,
}: {
  size?: number;
  className?: string;
}) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="-13 -13 26 26"
      xmlns="http://www.w3.org/2000/svg"
      className={className}
      aria-hidden="true"
    >
      <polygon
        points="-10.39,-6 0,-12 0,-6 -5.2,-3"
        fill="#ff7e72"
      />
      <polygon
        points="0,-12 10.39,-6 5.2,-3 0,-6"
        fill="#f25c4f"
      />
      <polygon
        points="10.39,-6 10.39,6 5.2,3 5.2,-3"
        fill="#cc342d"
      />
      <polygon
        points="10.39,6 0,12 0,6 5.2,3"
        fill="#6b1a16"
      />
      <polygon
        points="0,12 -10.39,6 -5.2,3 0,6"
        fill="#8a2018"
      />
      <polygon
        points="-10.39,6 -10.39,-6 -5.2,-3 -5.2,3"
        fill="#d83a30"
      />

      <polygon points="-5.2,-3 0,-6 0,0" fill="#ff9b91" />
      <polygon points="0,-6 5.2,-3 0,0" fill="#f55a4d" />
      <polygon points="5.2,-3 5.2,3 0,0" fill="#cc342d" />
      <polygon points="5.2,3 0,6 0,0" fill="#7a1a16" />
      <polygon points="0,6 -5.2,3 0,0" fill="#a32721" />
      <polygon points="-5.2,3 -5.2,-3 0,0" fill="#e2453d" />
    </svg>
  );
}
