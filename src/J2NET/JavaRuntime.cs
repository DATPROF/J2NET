using System;
using System.Diagnostics;
using System.IO;
using J2NET.Exceptions;
using J2NET.Utilities;

namespace J2NET
{
    public static class JavaRuntime
    {
        public static Process ExecuteJar(string value, string arguments = null, bool createNoWindow = false)
        {
            return Execute($"-jar {value}", arguments, createNoWindow);
        }

        public static Process ExecuteClass(string value, string arguments = null, bool createNoWindow = false)
        {
            return Execute($"-cp {value}", arguments, createNoWindow);
        }

        public static Process Execute(string value, string arguments = null, bool createNoWindow = false)
        {
            var runtimePath = PathUtility.GetRuntimePath();

            if (!Directory.Exists(Path.GetDirectoryName(runtimePath)))
                throw new RuntimeNotFoundException();

            var process = new Process
            {
                StartInfo = new ProcessStartInfo
                {
                    FileName = runtimePath,
                    Arguments = !string.IsNullOrEmpty(arguments)
                        ? $"{value} {arguments}"
                        : $"{value}",
                    CreateNoWindow = createNoWindow,
                }
            };
            process.Start();
            return process;
        }
    }
}
