# Use a base image with SSHFS and Samba installed
FROM ubuntu:latest

# Install SSHFS and Samba
RUN apt-get update && \
    apt-get install -y sshfs samba

# Add a non-root user for SSHFS mount
RUN useradd -m sshuser && echo "sshuser:sshpass" | chpasswd

# Create a directory to mount SSHFS
RUN mkdir /remote

# Create a Samba share directory
RUN mkdir /samba-share

# Copy Samba configuration
COPY smb.conf /etc/samba/smb.conf

# RUN chown -R sshuser:sshuser /samba-share
RUN chmod -R 777 /samba-share

# Enable 'user_allow_other' in /etc/fuse.conf
RUN echo "user_allow_other" >> /etc/fuse.conf

# Expose the necessary ports for Samba
EXPOSE 139 445

# Link the SSHFS mount to the Samba share
RUN ln -s /remote /samba-share/remote

# Start Samba server
CMD ["smbd", "--foreground", "--no-process-group", "--debug-stdout"]
