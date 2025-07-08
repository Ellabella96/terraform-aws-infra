set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_ROOT/scripts/setup-backend"

echo "WARNING: This script will destroy the Terraform backend resources!"
echo "This includes the S3 bucket containing your Terraform state files."
echo ""
read -p "Are you sure you want to continue? (yes/no): " confirm

if [ "$confirm" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

echo ""
read -p "Type 'DESTROY' to confirm: " destroy_confirm

if [ "$destroy_confirm" != "DESTROY" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Navigate to backend directory
cd "$BACKEND_DIR"

echo "Destroying Terraform backend..."
terraform destroy -auto-approve

echo "Backend resources destroyed."
echo ""
echo "Note: You should also clean up any remaining state files and"
echo "update your environment configurations to remove backend references."
