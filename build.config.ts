import { join, resolve } from "path";
import css from "rollup-plugin-import-css";
import sass from "rollup-plugin-sass";
import { getSassVariablesStringSync } from "node-sass-variables";
import { defineBuildConfig } from "unbuild";

const srcdir = resolve(join(__dirname, "src"));
const outDir = resolve(process.env.OUTDIR ?? join(__dirname, "dist"));

export default defineBuildConfig({
  entries: [
    {
      input: join(srcdir, "styling"),
      outDir,
      ext: "cjs",
    },
  ],
  hooks: {
    "rollup:options"(_ctx, options) {
      options.plugins.push(
        sass({
          include: join(srcdir, "styling", "**/*.scss"),
        })
      );

      options.plugins.push(
        css({
          include: join(srcdir, "styling", "**/*.scss"),
          transform(code: string) {
            const transform = ({
              type,
              value,
            }: {
              type: string;
              value: any;
            }) => {
              if (type === "SassMap" && typeof value === "object")
                return Object.fromEntries(
                  Object.entries(value).map(([name, value]) => [
                    name,
                    transform(value),
                  ])
                );
              if (type === "SassColor") return value.hex;
              return value;
            };

            return Object.fromEntries(
              Object.entries(
                getSassVariablesStringSync(code) as Record<string, any>
              ).map(([name, value]) => [name, transform(value)])
            );
          },
        })
      );
    },
  },
  outDir,
  rollup: {
    emitCJS: true,
    inlineDependencies: true,
  },
});
