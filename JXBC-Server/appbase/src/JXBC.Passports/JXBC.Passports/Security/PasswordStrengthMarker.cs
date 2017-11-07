using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace JXBC.Passports.Security
{
    /// <summary>
    /// 
    /// </summary>
    public static class PasswordStrengthMarker
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <returns></returns>
        public static int MarkScore(string password)
        {
            var score = 0;
            if (string.IsNullOrEmpty(password))
                return score;

            var containsLowercase = Regex.IsMatch(password, "[a-z]");
            var containsUppercase = Regex.IsMatch(password, "[A-Z]");
            var containsCase = containsLowercase | containsUppercase;

            var numberMacthes = Regex.Matches(password, "[0-9]");
            var containsNumber = numberMacthes.Count > 0;

            var specialCharacterMacthes = Regex.Matches(password, @"\W");
            var containsSpecialCharacter = specialCharacterMacthes.Count > 0;
            
            score += password.Length < 6 ? 5 : (password.Length >= 8 ? 25 : 10);
            score += !containsCase ? 0 : (containsLowercase && containsUppercase ? 20 : 10);
            score += !containsNumber ? 0 : (numberMacthes.Count >= 3 ? 20 : 10);
            score += !containsSpecialCharacter ? 0 : (specialCharacterMacthes.Count >= 1 ? 25 : 10);

            if (containsNumber && containsLowercase && containsUppercase && containsSpecialCharacter)
                score += 5;
            else if (containsNumber && containsCase && containsSpecialCharacter)
                score += 3;
            else if (containsNumber && containsCase)
                score += 2;

            if (ModuleEnvironment.WeakPasswords.Contains(password))
                score -= 100;
            return score;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <returns></returns>
        public static PasswordStrength MarkStrength(string password)
        {
            var score = MarkScore(password);

            if (score >= 90) return PasswordStrength.Securest;
            else if (score >= 80) return PasswordStrength.Secure;
            else if (score >= 70) return PasswordStrength.Strongest;
            else if (score >= 60) return PasswordStrength.Strong;
            else if (score >= 50) return PasswordStrength.Average;
            else if (score >= 25) return PasswordStrength.Weak;
            else return PasswordStrength.Weakest;
        }
    }
}